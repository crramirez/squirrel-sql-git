package org.squirrelsql.session.graph;

import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.canvas.Canvas;
import javafx.scene.control.*;
import javafx.scene.input.DragEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.TransferMode;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import org.squirrelsql.Props;
import org.squirrelsql.globalicons.GlobalIconNames;
import org.squirrelsql.services.Dao;
import org.squirrelsql.services.I18n;
import org.squirrelsql.services.MessageHandler;
import org.squirrelsql.services.MessageHandlerDestination;
import org.squirrelsql.session.Session;
import org.squirrelsql.session.TableInfo;
import org.squirrelsql.session.graph.graphdesktop.Window;
import org.squirrelsql.session.objecttree.ObjectTreeFilterCtrl;
import sun.awt.AppContext;

import java.util.List;

public class GraphPaneCtrl
{

   private final ToolBar _toolbar;
   private BorderPane _pane = new BorderPane();

   private final ScrollPane _scrollPane;
   private GraphTableDndChannel _graphTableDndChannel;
   private Session _session;
   private final Pane _desktopPane = new Pane();
   private final DrawLinesCtrl _drawLinesCtrl;

   private final Props _props = new Props(getClass());
   private final I18n _i18n = new I18n(getClass());


   public GraphPaneCtrl(GraphTableDndChannel graphTableDndChannel, Session session)
   {
      _graphTableDndChannel = graphTableDndChannel;
      _session = session;

      initDrop(_desktopPane);

      // init and show the stage
      // create a scene that displays the desktopPane (resolution 600,600)
      StackPane stackPane = new StackPane();

      _scrollPane = new ScrollPane();
      _drawLinesCtrl = new DrawLinesCtrl(_desktopPane, _scrollPane);


      Canvas sizingDummyPane = new Canvas();
      stackPane.getChildren().add(sizingDummyPane);
      SizeBindingHelper.bindSizingDummyCanvasToScrollPane(_scrollPane, sizingDummyPane);

      stackPane.getChildren().add(_drawLinesCtrl.getCanvas());
      stackPane.getChildren().add(_desktopPane);

      _desktopPane.addEventHandler(MouseEvent.MOUSE_CLICKED, e -> _drawLinesCtrl.mouseClicked(e));
      _desktopPane.addEventHandler(MouseEvent.MOUSE_PRESSED, e -> _drawLinesCtrl.mousePressed(e));
      _desktopPane.addEventHandler(MouseEvent.MOUSE_DRAGGED, e -> _drawLinesCtrl.mouseDragged(e));
      _desktopPane.addEventHandler(MouseEvent.MOUSE_RELEASED, e -> _drawLinesCtrl.mouseReleased(e));

      graphTableDndChannel.setShowtoolbarListener(this::onShowToolbar);

      _scrollPane.setContent(stackPane);

      _toolbar = createToolbar();



      _pane.setTop(_toolbar);
      _pane.setCenter(_scrollPane);
   }

   private void onShowToolbar(boolean b)
   {
      if (b)
      {
         _pane.setTop(_toolbar);
      }
      else
      {
         _pane.setTop(null);
      }
   }

   private ToolBar createToolbar()
   {
      ToolBar toolBar = new ToolBar();

      Button btnAddTable = new Button();
      btnAddTable.setGraphic(_props.getImageView("addTable.png"));
      btnAddTable.setTooltip(new Tooltip(_i18n.t("graph.add.table.button.tooltip")));
      btnAddTable.setOnAction(e -> onAddTables());
      toolBar.getItems().add(btnAddTable);

      Button btnSaveGraph = new Button();
      btnSaveGraph.setGraphic(_props.getImageView(GlobalIconNames.FILE_SAVE));
      btnSaveGraph.setTooltip(new Tooltip(_i18n.t("graph.save.graph")));
      btnSaveGraph.setOnAction(e -> onSaveGraph());
      toolBar.getItems().add(btnSaveGraph);

      return toolBar;
   }

   private void onSaveGraph()
   {
      GraphPersistence gp = new GraphPersistence();
      for (Node pkNode : _desktopPane.getChildren())
      {
         TableWindowCtrl ctrl = ((Window) pkNode).getCtrl();
         GraphTableInfo gti = new GraphTableInfo(ctrl);
         gp.getGraphTableInfos().add(gti);
      }

      MessageHandler mh = new MessageHandler(getClass(), MessageHandlerDestination.MESSAGE_PANEL);

      mh.info(_i18n.t("graph.wrote.file.to", Dao.writeGraphPersistence(gp).getPath()));
   }

   private void onAddTables()
   {
      new ObjectTreeFilterCtrl(_session, "", _graphTableDndChannel);
   }

   private void initDrop(Pane desktopPane)
   {
      desktopPane.setOnDragDropped(this::onDragDroppedOfTableFromObjectTreeDialogToDesktop);
      desktopPane.setOnDragOver(e -> onDragOverOfTableFromObjectTreeDialogToDesktop(e));
   }

   private void onDragOverOfTableFromObjectTreeDialogToDesktop(DragEvent dragEvent)
   {
      if (ObjectTreeFilterCtrl.DRAGGING_TO_QUERY_BUILDER.equals(dragEvent.getDragboard().getString()))
      {
         dragEvent.acceptTransferModes(TransferMode.MOVE);
      }
      dragEvent.consume();
   }

   private void onDragDroppedOfTableFromObjectTreeDialogToDesktop(DragEvent dragEvent)
   {
      if( ObjectTreeFilterCtrl.DRAGGING_TO_QUERY_BUILDER.equals(dragEvent.getDragboard().getString()) )
      {
         List<TableInfo> tableInfos = _graphTableDndChannel.getLastDroppedTableInfos();

         double offset = 0;
         for (TableInfo tableInfo : tableInfos)
         {
            double x = dragEvent.getX() + offset;
            double y = dragEvent.getY() + offset;

            TableWindowCtrl tableWindowCtrl = new TableWindowCtrl(_session, tableInfo, x, y, ctrl -> _drawLinesCtrl.doDraw());

            _desktopPane.getChildren().add(tableWindowCtrl.getWindow());

            offset += 10;
         }

         _drawLinesCtrl.doDraw();
      }
      dragEvent.consume();
   }


   public Node getPane()
   {
      return _pane;
   }
}
