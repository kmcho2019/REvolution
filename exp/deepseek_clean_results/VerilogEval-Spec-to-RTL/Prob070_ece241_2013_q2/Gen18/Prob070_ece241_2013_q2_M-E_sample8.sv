module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    wire [3:0] input_pattern = {a,b,c,d};
    
    // SOP Logic: Match patterns that output 1
    wire match_2  = (input_pattern == 4'b0010);
    wire match_7  = (input_pattern == 4'b0111);
    wire match_15 = (input_pattern == 4'b1111);
    assign out_sop = match_2 | match_7 | match_15;
    
    // POS Logic: Match patterns that output 0
    wire match_0  = (input_pattern == 4'b0000);
    wire match_1  = (input_pattern == 4'b0001);
    wire match_4  = (input_pattern == 4'b0100);
    wire match_5  = (input_pattern == 4'b0101);
    wire match_6  = (input_pattern == 4'b0110);
    wire match_9  = (input_pattern == 4'b1001);
    wire match_10 = (input_pattern == 4'b1010);
    wire match_13 = (input_pattern == 4'b1101);
    wire match_14 = (input_pattern == 4'b1110);
    
    assign out_pos = ~(match_0 | match_1 | match_4 | match_5 | 
                      match_6 | match_9 | match_10 | match_13 | match_14);

endmodule