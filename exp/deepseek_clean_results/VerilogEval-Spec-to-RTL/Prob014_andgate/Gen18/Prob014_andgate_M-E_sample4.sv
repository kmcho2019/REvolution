module TopModule(input a, b, output out);
    assign out = a ? b : 1'b0;
endmodule