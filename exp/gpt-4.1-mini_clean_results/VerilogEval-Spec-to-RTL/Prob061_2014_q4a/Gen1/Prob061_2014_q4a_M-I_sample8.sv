module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L)
        Q <= R;
    else if (E)
        Q <= w;
    // else hold state implicitly, no need to reassign Q
end

endmodule