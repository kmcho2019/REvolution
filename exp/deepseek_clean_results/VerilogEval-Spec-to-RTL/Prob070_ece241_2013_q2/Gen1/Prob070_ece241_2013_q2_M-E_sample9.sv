module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    wire [3:0] input_bus = {a,b,c,d};
    wire is_2, is_7, is_15;
    wire is_0, is_1, is_4, is_5, is_6, is_9, is_10, is_13, is_14;

    // Detect numbers for SOP (output 1 cases)
    assign is_2  = (input_bus == 4'b0010);
    assign is_7  = (input_bus == 4'b0111);
    assign is_15 = (input_bus == 4'b1111);
    assign out_sop = is_2 | is_7 | is_15;

    // Detect numbers for POS (output 0 cases)
    assign is_0  = (input_bus == 4'b0000);
    assign is_1  = (input_bus == 4'b0001);
    assign is_4  = (input_bus == 4'b0100);
    assign is_5  = (input_bus == 4'b0101);
    assign is_6  = (input_bus == 4'b0110);
    assign is_9  = (input_bus == 4'b1001);
    assign is_10 = (input_bus == 4'b1010);
    assign is_13 = (input_bus == 4'b1101);
    assign is_14 = (input_bus == 4'b1110);
    
    // POS is the complement of when any 0-case is true
    assign out_pos = ~(is_0 | is_1 | is_4 | is_5 | is_6 | is_9 | is_10 | is_13 | is_14);

endmodule