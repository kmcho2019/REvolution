module TopModule(
  input clk,
  input areset,
  input x,
  output reg z
);

reg [1:0] state;
localparam A = 2'b01;
localparam B = 2'b10;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    case (state)
      A: begin
        if (x) begin
          state <= B;
          z <= 1'b1;
        end else begin
          state <= A;
          z <= 1'b0;
        end
      end
      B: begin
        if (x) begin
          state <= B;
          z <= 1'b0;
        end else begin
          state <= B;
          z <= 1'b1;
        end
      end
      default: state <= A;
    endcase
  end
end

endmodule