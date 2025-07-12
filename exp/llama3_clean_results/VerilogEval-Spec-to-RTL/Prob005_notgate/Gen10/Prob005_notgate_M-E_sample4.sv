module TopModule(
    input  in,
    output out
);
    wire inverted_in;
    assign inverted_in = ~in;
    assign out = (1'b1) ? inverted_in : in;
endmodule