module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

reg [2:0] state;

always @(posedge clk) begin
    case(state)
        3'b000: begin
            Y0 = x;
            z = 0;
            state <= 3'b000;
        end
        3'b001: begin
            Y0 = x;
            z = 0;
            state <= 3'b001;
        end
        3'b010: begin
            Y0 = ~x;
            z = 0;
            state <= 3'b001;
        end
        3'b011: begin
            Y0 = ~x;
            z = 1;
            state <= 3'b010;
        end
        3'b100: begin
            Y0 = x & ~y[1];
            z = y[0];
            state <= 3'b100;
        end
        default: state <= 3'b000; // default to state 000
    endcase
end

initial begin
    state <= 3'b000;
end

endmodule