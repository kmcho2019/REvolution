module TopModule(
    input x,
    input y,
    output reg z
);
    // Using an always block to describe the combinational logic.
    // The always block is sensitive to changes in x and y.
    always @(*) begin
        // The output z is 1 when x and y are the same (both 0 or both 1),
        // which can be efficiently represented using the XOR operator (^).
        // The ! operator inverts the result, making z high when x equals y.
        z = !(x ^ y);
    end
endmodule