module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits (nearest power of 2) by adding one zero bit
    wire [255:0] padded_in = {1'b0, in};

    // Break into 64 4-bit chunks and count '1's in each
    wire [5:0] count_4bit [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : count_4bit_chunks
            // LUT-based 4-bit population count (0-4)
            always @(*) begin
                case (padded_in[i*4 +: 4])
                    4'b0000: count_4bit[i] = 3'b000;
                    4'b0001: count_4bit[i] = 3'b001;
                    4'b0010: count_4bit[i] = 3'b001;
                    4'b0011: count_4bit[i] = 3'b010;
                    4'b0100: count_4bit[i] = 3'b001;
                    4'b0101: count_4bit[i] = 3'b010;
                    4'b0110: count_4bit[i] = 3'b010;
                    4'b0111: count_4bit[i] = 3'b011;
                    4'b1000: count_4bit[i] = 3'b001;
                    4'b1001: count_4bit[i] = 3'b010;
                    4'b1010: count_4bit[i] = 3'b010;
                    4'b1011: count_4bit[i] = 3'b011;
                    4'b1100: count_4bit[i] = 3'b010;
                    4'b1101: count_4bit[i] = 3'b011;
                    4'b1110: count_4bit[i] = 3'b011;
                    4'b1111: count_4bit[i] = 3'b100;
                endcase
            end
        end
    endgenerate

    // Balanced binary adder tree
    // First level: 32 adders (64 inputs)
    wire [6:0] sum_level1 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : level1_adders
            assign sum_level1[i] = count_4bit[i*2] + count_4bit[i*2+1];
        end
    endgenerate

    // Second level: 16 adders (32 inputs)
    wire [7:0] sum_level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign sum_level2[i] = sum_level1[i*2] + sum_level1[i*2+1];
        end
    endgenerate

    // Third level: 8 adders (16 inputs)
    wire [7:0] sum_level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level3_adders
            assign sum_level3[i] = sum_level2[i*2] + sum_level2[i*2+1];
        end
    endgenerate

    // Fourth level: 4 adders (8 inputs)
    wire [7:0] sum_level4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level4_adders
            assign sum_level4[i] = sum_level3[i*2] + sum_level3[i*2+1];
        end
    endgenerate

    // Fifth level: 2 adders (4 inputs)
    wire [7:0] sum_level5 [0:1];
    assign sum_level5[0] = sum_level4[0] + sum_level4[1];
    assign sum_level5[1] = sum_level4[2] + sum_level4[3];

    // Final adder (2 inputs)
    assign out = sum_level5[0] + sum_level5[1];

endmodule