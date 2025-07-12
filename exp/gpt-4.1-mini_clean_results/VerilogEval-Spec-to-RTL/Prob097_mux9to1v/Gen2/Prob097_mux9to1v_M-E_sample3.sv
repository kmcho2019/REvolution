module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

    // Concatenate all inputs into one 144-bit vector (9 * 16)
    wire [143:0] concat_inputs = {a, b, c, d, e, f, g, h, i};

    always @(*) begin
        if (sel <= 4'd8) begin
            // Extract 16-bit slice according to sel: index counting from MSB (a) down to LSB (i)
            // Calculate the bit index offset for the slice
            // Since 'a' is MSB, we start at bit 143 for sel=0
            out = concat_inputs[143 - sel*16 -: 16];
        end else begin
            out = 16'hFFFF;
        end
    end

endmodule