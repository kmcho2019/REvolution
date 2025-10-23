module TopModule #(
    parameter WIDTH = 8,
    parameter RESET_VALUE = 8'h34
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

always @(negedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule