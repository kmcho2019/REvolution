module TopModule (
    input clk, w, R, E, L,
    output reg Q
);

always @(posedge clk) begin
    if (L)
        Q <= R;
    else if (E)
        Q <= w;
    // else Q retains its value (implied)
end

endmodule