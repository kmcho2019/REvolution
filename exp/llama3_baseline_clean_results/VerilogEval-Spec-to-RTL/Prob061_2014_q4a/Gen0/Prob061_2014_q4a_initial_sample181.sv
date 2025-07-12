module TopModule(
    input       clk,
    input       w,
    input       R,
    input       E,
    input       L,
    output reg  Q
);

always @(posedge clk) begin
    if (L) begin
        // Load the value from input R when load signal L is asserted
        Q <= R;
    end else if (E) begin
        // Shift in the value from the previous stage when enable signal E is asserted
        Q <= w;
    end
end

endmodule