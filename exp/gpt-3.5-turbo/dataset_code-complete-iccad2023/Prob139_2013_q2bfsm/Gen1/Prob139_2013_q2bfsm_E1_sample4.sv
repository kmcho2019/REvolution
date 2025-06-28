module EdgeDetector (
  input signal,
  input clk,
  output reg edge
);
  reg signal_delay;
  always @ (posedge clk) begin
    signal_delay <= signal;
    edge <= !signal_delay && signal;
  end
endmodule

module FSM (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);
  reg [1:0] state;
  reg [2:0] x_history;
  reg [1:0] y_counter;

  reg reset_edge;

  EdgeDetector reset_detector (
    .signal(resetn),
    .clk(clk),
    .edge(reset_edge)
  );

  always @ (posedge clk or negedge resetn) begin
    if (~resetn || reset_edge) begin
      state <= 2'b00; // State A
      f <= 0;
      g <= 0;
    end
    else begin
      case (state)
        2'b00: begin // State A
          f <= 1;
          state <= 2'b01; // Transition to State B
        end
        2'b01: begin // State B
          if (x_history == 3'b101) begin
            state <= 2'b10; // Transition to State C
          end
          x_history <= {x_history[1:0], x};
        end
        2'b10: begin // State C
          if (g == 1) begin
            if (y == 1) begin
                g <= 1;
            end
            else begin
              if (y_counter < 2) begin
                y_counter <= y_counter + 1;
              end
              else begin
                g <= 0;
              end
            end
          end
          else begin
            if (y == 1) begin
              state <= 2'b10; // Stay in State C
              g <= 1;
            end
          end
        end
        default: state <= 2'b00;
      endcase
    end
  end
endmodule

module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);
  FSM fsm (
    .clk(clk),
    .resetn(resetn),
    .x(x),
    .y(y),
    .f(f),
    .g(g)
  );
endmodule