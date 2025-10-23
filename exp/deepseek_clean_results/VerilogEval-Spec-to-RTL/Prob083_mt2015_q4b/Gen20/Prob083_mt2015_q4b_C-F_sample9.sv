module TopModule (
    input x,
    input y,
    output reg z
);
    // z = 1 when x and y are equal (XNOR operation)
    always @(x or y) begin
        z = ~(x ^ y);  // Explicit XNOR implementation
    end
endmodule