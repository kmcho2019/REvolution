module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) Q <= R;
    else if (E) Q <= w;
    // Else, Q retains its value, which is the default behavior for reg type in Verilog
end

endmodule