module TopModule(
    input  in,
    output out
);
    wire buf;
    assign buf = ~in;
    assign out = ~buf;
endmodule