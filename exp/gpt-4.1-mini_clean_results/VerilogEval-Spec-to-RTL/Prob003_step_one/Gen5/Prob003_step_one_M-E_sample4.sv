module TopModule(output wire one);
    localparam logic const_one = 1'b1;
    wire internal_one;
    assign internal_one = const_one;
    assign one = internal_one;
endmodule