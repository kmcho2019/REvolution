module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case (c[1:0])  // Only need to check lower 2 bits for values 0-3
        2'b00: q = b;    // c = 0: output b
        2'b01: q = e;    // c = 1: output e
        2'b10: q = a;    // c = 2: output a
        2'b11: q = d;    // c = 3: output d
        default: q = 4'b1111; // c >=4: output 'f' (should never reach here)
    endcase

    // Efficiently handle c >=4 cases using bitwise OR
    if (|c[3:2]) q = 4'b1111;
end

endmodule