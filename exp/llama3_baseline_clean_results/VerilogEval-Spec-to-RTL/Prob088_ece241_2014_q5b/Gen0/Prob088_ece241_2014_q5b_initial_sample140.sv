module TopModule(
  input clk,
  input areset,
  input x,
  output reg z
);

reg [1:0] state;
localparam A = 2'b10, B = 2'b01;

always @(posedge clk or posedge areset) begin
  if(areset) begin
    state <= A;
  end else begin
    case(state)
      A: begin
        if(x) begin
          state <= B;
        end else begin
          state <= A;
        end
      end
      B: begin
        state <= B; // since from B it always goes to B
      end
      default: state <= A;
    endcase
  end
end

always @(*) begin
  case(state)
    A: z = ~x;
    B: z = x;
    default: z = 1'bx;
  endcase
end

endmodule