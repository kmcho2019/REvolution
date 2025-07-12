// TopModule with 8 D flip-flops and active high synchronous reset
module TopModule #(
    parameter RESET_VALUE = 8'h34, // Parameter for reset value
    parameter WIDTH = 8 // Parameter for data width
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        for (int i = 0; i < WIDTH; i++) begin
            q_reg[i] <= RESET_VALUE[i];
        end
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule