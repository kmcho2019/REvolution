module TopModule(
    input  in,
    output out
);
    wire inv_in;
    assign inv_in = ~in;
    assign out = inv_in;
endmodule