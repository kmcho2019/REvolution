module TopModule(
  input clk,
  input areset,
  input in,
  output reg out
);

// Define states
parameter A = 2'd0;
parameter B = 2'd1;
parameter C = 2'd2;
parameter D = 2'd3;

// Define the state register
reg [1:0] state;

// Sequential logic for state update with asynchronous reset and output logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
    out <= 0;
  end else begin
    case (state)
      A: begin
        state <= in ? B : A;
        out <= 0;
      end
      B: begin
        state <= in ? B : C;
        out <= 0;
      end
      C: begin
        state <= in ? D : A;
        out <= 0;
      end
      D: begin
        state <= in ? B : C;
        out <= 1;
      end
      default: begin
        state <= A;
        out <= 0;
      end
    endcase
  end
end

endmodule