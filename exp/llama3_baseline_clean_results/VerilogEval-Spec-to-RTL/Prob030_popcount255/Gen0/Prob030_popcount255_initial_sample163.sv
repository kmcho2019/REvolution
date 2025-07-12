module TopModule(
    input [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Count the number of '1's in each 16-bit chunk
reg [4:0] count0, count1, count2, count3, count4, count5, count6, count7, 
         count8, count9, count10, count11, count12, count13, count14, count15;

// The last chunk is 7 bits
reg [2:0] count16;

always @(in) begin
    count0 = {1'b0, 15'd0}; 
    count1 = {1'b0, 15'd0}; 
    count2 = {1'b0, 15'd0}; 
    count3 = {1'b0, 15'd0}; 
    count4 = {1'b0, 15'd0}; 
    count5 = {1'b0, 15'd0}; 
    count6 = {1'b0, 15'd0}; 
    count7 = {1'b0, 15'd0}; 
    count8 = {1'b0, 15'd0}; 
    count9 = {1'b0, 15'd0}; 
    count10 = {1'b0, 15'd0}; 
    count11 = {1'b0, 15'd0}; 
    count12 = {1'b0, 15'd0}; 
    count13 = {1'b0, 15'd0}; 
    count14 = {1'b0, 15'd0}; 
    count15 = {1'b0, 15'd0}; 
    count16 = {1'b0, 2'd0};

    // Calculate population count for each 16-bit chunk
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            if (in[i*16 + j]) begin
                if (i < 16) begin
                    case (j)
                        0: count0 = count0 + 1;
                        1: count0 = count0 + 1;
                        2: count0 = count0 + 1;
                        3: count0 = count0 + 1;
                        4: count0 = count0 + 1;
                        5: count0 = count0 + 1;
                        6: count0 = count0 + 1;
                        7: count0 = count0 + 1;
                        8: count0 = count0 + 1;
                        9: count0 = count0 + 1;
                        10: count0 = count0 + 1;
                        11: count0 = count0 + 1;
                        12: count0 = count0 + 1;
                        13: count0 = count0 + 1;
                        14: count0 = count0 + 1;
                        15: count0 = count0 + 1;
                    endcase
                end else if (i == 16) begin
                    case (j)
                        0: count16 = count16 + 1;
                        1: count16 = count16 + 1;
                        2: count16 = count16 + 1;
                        3: count16 = count16 + 1;
                        4: count16 = count16 + 1;
                        5: count16 = count16 + 1;
                        6: count16 = count16 + 1;
                    endcase
                end
            end
        end
        case (i)
            1: count1 = count0;
            2: count2 = count1;
            3: count3 = count2;
            4: count4 = count3;
            5: count5 = count4;
            6: count6 = count5;
            7: count7 = count6;
            8: count8 = count7;
            9: count9 = count8;
            10: count10 = count9;
            11: count11 = count10;
            12: count12 = count11;
            13: count13 = count12;
            14: count14 = count13;
            15: count15 = count14;
        endcase
    end

    // Sum up counts of '1's in all chunks
    count = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7 + 
            count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15 + count16;
    out = count;
end

endmodule