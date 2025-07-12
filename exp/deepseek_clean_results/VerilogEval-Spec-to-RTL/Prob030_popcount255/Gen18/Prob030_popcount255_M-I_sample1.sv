module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Pad input to 256 bits (next power of 2)
    wire [255:0] padded_in = {in, 1'b0};

    // Level 1: Count '1's in 4-bit chunks (64 chunks) using LUTs
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level1_counters
            wire [3:0] group = padded_in[i*4 +: 4];
            always @(*) begin
                case(group)
                    4'b0000: level1[i] = 3'b000;
                    4'b0001: level1[i] = 3'b001;
                    4'b0010: level1[i] = 3'b001;
                    4'b0011: level1[i] = 3'b010;
                    4'b0100: level1[i] = 3'b001;
                    4'b0101: level1[i] = 3'b010;
                    4'b0110: level1[i] = 3'b010;
                    4'b0111: level1[i] = 3'b011;
                    4'b1000: level1[i] = 3'b001;
                    4'b1001: level1[i] = 3'b010;
                    4'b1010: level1[i] = 3'b010;
                    4'b1011: level1[i] = 3'b011;
                    4'b1100: level1[i] = 3'b010;
                    4'b1101: level1[i] = 3'b011;
                    4'b1110: level1[i] = 3'b011;
                    4'b1111: level1[i] = 3'b100;
                endcase
            end
        end
    endgenerate

    // Level 2: Sum 4 level1 counters (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                              level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Level 3: Sum 4 level2 counters (4 groups)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*4] + level2[i*4+1] + 
                              level2[i*4+2] + level2[i*4+3];
        end
    endgenerate

    // Final level: Balanced binary tree summation
    wire [7:0] sum_ab = level3[0] + level3[1];
    wire [7:0] sum_cd = level3[2] + level3[3];
    assign out = sum_ab + sum_cd;

endmodule