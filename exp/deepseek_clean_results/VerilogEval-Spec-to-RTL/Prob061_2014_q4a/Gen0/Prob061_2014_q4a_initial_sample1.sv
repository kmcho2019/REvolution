module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L)         // Load mode has highest priority
        Q <= R;
    else if (E)    // Shift mode
        Q <= w;
    // else hold - Q remains unchanged
end

endmodule