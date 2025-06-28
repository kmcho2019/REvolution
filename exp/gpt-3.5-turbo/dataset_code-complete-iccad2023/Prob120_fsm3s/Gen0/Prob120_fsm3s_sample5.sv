module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out,
  output reg [1:0] state
);

  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
      out <= 1'b0;
    end
    else begin
      case (state)
        A: begin
          if (in)
            state <= B;
          else
            state <= A;
          out <= 1'b0;
        end
        B: begin
          if (in)
            state <= B;
          else
            state <= C;
          out <= 1'b0;
        end
        C: begin
          if (in)
            state <= D;
          else
            state <= A;
          out <= 1'b0;
        end
        D: begin
          if (in)
            state <= B;
          else
            state <= C;
          out <= 1'b1;
        end
      endcase
    end
  end

endmodule

module TopModule (
  input clk,
  input in,
  input reset,
  output out
);

  MooreStateMachine fsm (
    .clk(clk),
    .in(in),
    .reset(reset),
    .out(out)
  );

endmodule