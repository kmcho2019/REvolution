module TopModule(output one);
    wire const_one;
    assign const_one = 1'b1;
    assign one = const_one;
endmodule