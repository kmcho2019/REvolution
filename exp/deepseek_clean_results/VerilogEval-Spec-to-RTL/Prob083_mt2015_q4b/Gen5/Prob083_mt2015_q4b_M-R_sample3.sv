module TopModule (
    input x,
    input y,
    output reg z
);
    // Alternative implementation using procedural block
    // z is 1 when inputs are equal (XNOR functionality)
    always @(x or y) begin
        z = (x == y);  // Equivalent to ~(x ^ y) but more readable
    end
endmodule