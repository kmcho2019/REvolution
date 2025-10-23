module TopModule(
    output zero
);
    wire not_output;
    assign not_output = ~1'b1;
    assign zero = not_output;
endmodule