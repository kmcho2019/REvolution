module TopModule(
    input  in1,
    input  in2,
    output out
);
    wire not_in1;
    wire not_in2;
    wire and_out;

    assign not_in1 = ~in1;
    assign not_in2 = ~in2;
    assign and_out = not_in1 & not_in2;
    assign out = and_out;
endmodule