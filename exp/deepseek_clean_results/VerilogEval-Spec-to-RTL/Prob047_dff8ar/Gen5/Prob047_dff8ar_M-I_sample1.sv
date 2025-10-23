module TopModule #(
    parameter WIDTH = 8,
    parameter RESET_VAL = 8'b0
) (
    input clk,
    input areset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

reg [WIDTH-1:0] d_prev;
wire clk_enable = (d != d_prev);

always @(posedge clk or posedge areset) begin : dff_block
    if (areset) begin
        q <= RESET_VAL;
        d_prev <= RESET_VAL;
    end
    else if (clk_enable) begin
        q <= d;
        d_prev <= d;
    end
end

endmodule