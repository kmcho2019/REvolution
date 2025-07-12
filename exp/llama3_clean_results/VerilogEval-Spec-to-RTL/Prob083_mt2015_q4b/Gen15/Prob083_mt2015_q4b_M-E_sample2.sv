module TopModule(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        // Using the property that z is 1 when x equals y,
        // which can be represented as !(x ^ y).
        z = !(x ^ y);
    end
endmodule