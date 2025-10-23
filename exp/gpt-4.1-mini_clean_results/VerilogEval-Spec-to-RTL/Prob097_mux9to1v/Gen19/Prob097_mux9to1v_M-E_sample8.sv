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

    // Concatenate inputs into one wide vector: i is most significant segment, a least
    wire [143:0] concat_inputs = {i, h, g, f, e, d, c, b, a}; // 9*16=144 bits

    always @(*) begin
        if (sel <= 4'd8) begin
            // Calculate bit offset for desired 16-bit segment
            // Each segment is 16 bits, sel=0 picks bits [15:0], sel=1 picks [31:16], ...
            integer bit_offset;
            bit_offset = sel * 16;
            // Extract corresponding 16 bits
            out = concat_inputs >> bit_offset;
        end else begin
            out = 16'hFFFF;
        end
    end

endmodule