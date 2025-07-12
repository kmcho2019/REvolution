module TopModule(output zero);
    wire const_one;
    wire const_zero;

    // Tie const_one to 1
    assign const_one = 1'b1;
    // Tie const_zero to 0
    assign const_zero = 1'b0;

    // AND gate with inputs 0 and 1 always outputs 0
    assign zero = const_zero & const_one;
endmodule