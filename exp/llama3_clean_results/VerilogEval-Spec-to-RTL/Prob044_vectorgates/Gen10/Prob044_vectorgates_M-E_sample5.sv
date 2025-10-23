module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    reg [2:0] inv_a, inv_b;

    // Calculate bitwise-OR of a and b
    assign out_or_bitwise = a | b;

    // Calculate logical-OR of a and b
    assign out_or_logical = (a != 3'b000) || (b != 3'b000);

    // Calculate inverse of a and b
    always @(*) begin
        inv_a = ~a;
        inv_b = ~b;
    end

    // Combine inverses of a and b into out_not
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule