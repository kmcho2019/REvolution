module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

parameter RESET_VALUE = 1'b0;  // Allows easy reset value modification

always @(posedge clk or posedge ar) begin
    if (ar)
        q <= RESET_VALUE;
    else if (d != q)  // Only update when data changes (implicit clock gating)
        q <= d;
end

endmodule