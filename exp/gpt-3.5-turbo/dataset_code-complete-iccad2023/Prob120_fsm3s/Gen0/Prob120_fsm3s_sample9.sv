module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out,
  output reg [1:0] state
);

  // Define states
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
      out <= 0;
    end
    else begin
      case (state)
        A: begin
          if (in) state <= B;
          else state <= A;
          out <= 0;
        end
        B: begin
          if (in) state <= C;
          else state <= B;
          out <= 0;
        end
        C: begin
          if (in) state <= D;
          else state <= A;
          out <= 0;
        end
        D: begin
          if (in) state <= B;
          else state <= C;
          out <= 1;
        end
      endcase
    end
  end

endmodule