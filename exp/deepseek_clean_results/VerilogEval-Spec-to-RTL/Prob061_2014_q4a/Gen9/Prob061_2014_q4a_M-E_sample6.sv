module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg shadow_Q;

// Shadow register updates combinationally
always @* begin
    if (L)
        shadow_Q = R;
    else if (E)
        shadow_Q = w;
    else
        shadow_Q = Q;  // maintain state
end

// Main register simply copies shadow on clock edge
always @(posedge clk) begin
    Q <= shadow_Q;
end

endmodule