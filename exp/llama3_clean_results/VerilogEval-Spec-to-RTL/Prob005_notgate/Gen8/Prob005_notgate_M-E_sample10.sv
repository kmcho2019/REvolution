module TopModule(
    input  in,
    output out
);
    wire inverted_in;
    assign inverted_in = ~in;
    assign out = inverted_in;
endmodule