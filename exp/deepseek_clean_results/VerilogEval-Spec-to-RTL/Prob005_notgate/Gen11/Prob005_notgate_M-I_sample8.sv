module TopModule (
    input in,
    output out
);
    // NOT gate implemented with continuous assignment
    assign out = ~in;
endmodule