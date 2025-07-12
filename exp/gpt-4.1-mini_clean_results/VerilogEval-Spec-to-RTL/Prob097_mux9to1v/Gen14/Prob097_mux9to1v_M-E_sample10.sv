module TopModule (
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

    // Concatenate inputs into a single 144-bit vector (9 * 16)
    wire [143:0] inputs_concat = {a, b, c, d, e, f, g, h, i};

    // Calculate the bit offset for selected 16-bit segment (only valid for sel < 9)
    // Indexing from MSB, so offset = (8 - sel) * 16
    wire [7:0] offset = (4'd8 - sel) << 4;

    always @(*) begin
        if (sel < 4'd9) begin
            // Extract 16 bits starting at 'offset' from inputs_concat
            out = inputs_concat[offset +: 16];
        end else begin
            out = 16'hFFFF;
        end
    end

endmodule