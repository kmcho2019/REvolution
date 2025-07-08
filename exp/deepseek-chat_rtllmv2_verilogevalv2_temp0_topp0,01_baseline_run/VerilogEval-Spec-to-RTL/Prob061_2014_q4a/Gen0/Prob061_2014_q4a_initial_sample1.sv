module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= R;  // Load mode
    end
    else if (E) begin
        Q <= w;  // Shift mode
    end
    // Else: hold current value (implicit)
end

endmodule