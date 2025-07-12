module TopModule(
    input  logic in,
    output logic out
);
    assign out = in & 1'b1;
endmodule