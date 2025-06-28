module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  reg [1:0] state;
  reg [2:0] shift_reg;

  parameter A = 2'b00, B = 2'b01, C = 2'b10;

  always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
      state <= A;
      shift_reg <= 3'b0;
      z <= 1'b0;
    end else begin
      case (state)
        A: begin
          if (x) begin
            state <= B;
          end
        end
        B: begin
          if (x) begin
            state <= C;
            shift_reg <= {shift_reg[1:0], x};
          end else begin
            state <= A;
          end
        end
        C: begin
          if (x) begin
            shift_reg <= {shift_reg[1:0], x};
          else begin
            state <= A;
          end
          if (shift_reg == 3'b101) begin
            z <= 1'b1;
          end
        end
        default: state <= A;
      endcase
    end
  end
endmodule