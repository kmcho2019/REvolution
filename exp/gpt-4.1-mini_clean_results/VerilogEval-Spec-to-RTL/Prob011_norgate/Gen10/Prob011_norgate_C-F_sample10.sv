module TopModule (
    input  a,
    input  b,
    output out
);

    wire nor_result = ~|{a, b};
    assign out = nor_result;

endmodule