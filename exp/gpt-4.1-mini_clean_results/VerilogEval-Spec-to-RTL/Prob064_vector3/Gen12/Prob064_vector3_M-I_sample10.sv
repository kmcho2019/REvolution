module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Combine inputs into a 30-bit vector
    wire [29:0] input_concat = {a, b, c, d, e, f};

    // Two LSB bits registered to reduce glitches and toggling on constant bits
    reg [1:0] lsb_bits;

    // Register to fix appended bits as '11'
    always @(*) begin
        lsb_bits = 2'b11;
    end

    // Assign outputs by concatenating input bits plus registered last 2 bits
    // Assigning the outputs in order: w is MSB chunk, z is LSB chunk
    assign {w, x, y, z} = {input_concat, lsb_bits};

endmodule