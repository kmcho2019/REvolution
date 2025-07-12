module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits for uniform processing
    wire [255:0] padded_in = {1'b0, in};

    // Function to count 1s in 4-bit chunks using LUT
    function [2:0] count4;
        input [3:0] bits;
        begin
            case (bits)
                4'b0000: count4 = 3'b000;
                4'b0001: count4 = 3'b001;
                4'b0010: count4 = 3'b001;
                4'b0011: count4 = 3'b010;
                4'b0100: count4 = 3'b001;
                4'b0101: count4 = 3'b010;
                4'b0110: count4 = 3'b010;
                4'b0111: count4 = 3'b011;
                4'b1000: count4 = 3'b001;
                4'b1001: count4 = 3'b010;
                4'b1010: count4 = 3'b010;
                4'b1011: count4 = 3'b011;
                4'b1100: count4 = 3'b010;
                4'b1101: count4 = 3'b011;
                4'b1110: count4 = 3'b011;
                4'b1111: count4 = 3'b100;
            endcase
        end
    endfunction

    // First level: Count 1s in 4-bit chunks (64 chunks)
    wire [2:0] count4_level [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : count4_gen
            assign count4_level[i] = count4(padded_in[i*4 +: 4]);
        end
    endgenerate

    // Second level: Sum pairs of 4-bit counts (32 adders)
    wire [3:0] count8_level [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : count8_gen
            assign count8_level[i] = count4_level[i*2] + count4_level[i*2+1];
        end
    endgenerate

    // Third level: Sum pairs of 8-bit counts (16 adders)
    wire [4:0] count16_level [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : count16_gen
            assign count16_level[i] = count8_level[i*2] + count8_level[i*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs of 16-bit counts (8 adders)
    wire [5:0] count32_level [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : count32_gen
            assign count32_level[i] = count16_level[i*2] + count16_level[i*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs of 32-bit counts (4 adders)
    wire [6:0] count64_level [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : count64_gen
            assign count64_level[i] = count32_level[i*2] + count32_level[i*2+1];
        end
    endgenerate

    // Sixth level: Sum pairs of 64-bit counts (2 adders)
    wire [7:0] count128_level [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : count128_gen
            assign count128_level[i] = count64_level[i*2] + count64_level[i*2+1];
        end
    endgenerate

    // Final addition
    assign out = count128_level[0] + count128_level[1];

endmodule