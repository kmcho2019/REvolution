module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] borrow; // borrow[i] is borrow out of bit i
    
    // Instantiate 64 1-bit full subtractors chained by borrow signals
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : bit_sub
            if (i == 0) begin
                full_sub_1bit fs(
                    .a       (A[i]),
                    .b       (B[i]),
                    .borrow_in(1'b0),
                    .diff    (result[i]),
                    .borrow_out(borrow[i])
                );
            end else begin
                full_sub_1bit fs(
                    .a       (A[i]),
                    .b       (B[i]),
                    .borrow_in(borrow[i-1]),
                    .diff    (result[i]),
                    .borrow_out(borrow[i])
                );
            end
        end
    endgenerate

    // Overflow detection for signed subtraction:
    // overflow = (A[63] != B[63]) && (result[63] != A[63])
    assign overflow = (A[63] ^ B[63]) & (result[63] ^ A[63]);

endmodule


// 1-bit Full Subtractor Module
module full_sub_1bit (
    input  wire a,
    input  wire b,
    input  wire borrow_in,
    output wire diff,
    output wire borrow_out
);
    // diff = a - b - borrow_in
    assign diff = a ^ b ^ borrow_in;
    // borrow_out = (~a & b) | ((~a | b) & borrow_in)
    assign borrow_out = (~a & b) | ((~a | b) & borrow_in);
endmodule