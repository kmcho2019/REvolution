module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Function to count 1s in 5-bit chunks using LUT
    function [2:0] count5;
        input [4:0] bits;
        begin
            case (bits)
                5'b00000: count5 = 3'd0;
                5'b00001: count5 = 3'd1;
                5'b00010: count5 = 3'd1;
                5'b00011: count5 = 3'd2;
                5'b00100: count5 = 3'd1;
                5'b00101: count5 = 3'd2;
                5'b00110: count5 = 3'd2;
                5'b00111: count5 = 3'd3;
                5'b01000: count5 = 3'd1;
                5'b01001: count5 = 3'd2;
                5'b01010: count5 = 3'd2;
                5'b01011: count5 = 3'd3;
                5'b01100: count5 = 3'd2;
                5'b01101: count5 = 3'd3;
                5'b01110: count5 = 3'd3;
                5'b01111: count5 = 3'd4;
                5'b10000: count5 = 3'd1;
                5'b10001: count5 = 3'd2;
                5'b10010: count5 = 3'd2;
                5'b10011: count5 = 3'd3;
                5'b10100: count5 = 3'd2;
                5'b10101: count5 = 3'd3;
                5'b10110: count5 = 3'd3;
                5'b10111: count5 = 3'd4;
                5'b11000: count5 = 3'd2;
                5'b11001: count5 = 3'd3;
                5'b11010: count5 = 3'd3;
                5'b11011: count5 = 3'd4;
                5'b11100: count5 = 3'd3;
                5'b11101: count5 = 3'd4;
                5'b11110: count5 = 3'd4;
                5'b11111: count5 = 3'd5;
            endcase
        end
    endfunction

    // First level: count 5-bit chunks
    wire [4:0]  chunks [0:50];
    wire [2:0]  counts [0:50];
    
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin : COUNT_CHUNKS
            if (i < 50) begin
                assign chunks[i] = in[i*5+4:i*5];
            end else begin
                // Last chunk is only 5 bits (255 = 50*5 + 5)
                assign chunks[50] = {in[254], 4'b0}; // Pad with zeros
            end
            assign counts[i] = count5(chunks[i]);
        end
    endgenerate

    // Second level: sum pairs (25 sums)
    wire [3:0] sum1 [0:24];
    generate
        for (i = 0; i < 25; i = i + 1) begin : SUM_PAIRS
            if (i < 25) begin
                assign sum1[i] = counts[i*2] + counts[i*2+1];
            end
        end
    endgenerate

    // Third level: sum quads (13 sums)
    wire [4:0] sum2 [0:12];
    generate
        for (i = 0; i < 12; i = i + 1) begin : SUM_QUADS
            assign sum2[i] = sum1[i*2] + sum1[i*2+1];
        end
        assign sum2[12] = sum1[24]; // Last odd sum
    endgenerate

    // Fourth level: sum octs (7 sums)
    wire [5:0] sum3 [0:6];
    generate
        for (i = 0; i < 6; i = i + 1) begin : SUM_OCTS
            assign sum3[i] = sum2[i*2] + sum2[i*2+1];
        end
        assign sum3[6] = sum2[12]; // Last odd sum
    endgenerate

    // Fifth level: final sum
    assign out = sum3[0] + sum3[1] + sum3[2] + 
                 sum3[3] + sum3[4] + sum3[5] + sum3[6];

endmodule