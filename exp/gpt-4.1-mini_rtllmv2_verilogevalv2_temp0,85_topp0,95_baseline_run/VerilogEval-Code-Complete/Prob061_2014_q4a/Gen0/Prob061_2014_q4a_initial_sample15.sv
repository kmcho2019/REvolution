module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L)          // Load value R when load is asserted
        Q <= R;
    else if (E)     // Shift in w when enable is asserted and not loading
        Q <= w;
    else            // Retain previous value otherwise
        Q <= Q;
end

endmodule