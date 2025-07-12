module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Use a single continuous assignment with concatenation and bit slicing for reversal
    // This assigns out = in reversed bitwise from MSB to LSB
    generate
        if (WIDTH == 8) begin
            assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
        end else begin
            // For other widths, use a generate loop to build the reversed vector
            // This fallback is for parameterized usage beyond 8 bits
            integer i;
            reg [WIDTH-1:0] rev;
            always @(*) begin
                for (i = 0; i < WIDTH; i = i + 1) begin
                    rev[i] = in[WIDTH-1 - i];
                end
            end
            assign out = rev;
        end
    endgenerate
endmodule

module TopModule(
    input  [7:0] in,
    output [7:0] out
);
    BitReverser #(.WIDTH(8)) reverser_inst (
        .in(in),
        .out(out)
    );
endmodule