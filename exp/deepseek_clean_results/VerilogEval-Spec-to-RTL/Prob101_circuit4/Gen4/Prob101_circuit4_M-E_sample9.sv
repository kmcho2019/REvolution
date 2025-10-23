module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Implement using a multiplexer approach
    // q = (b || c) ? 1 : 0;
    assign q = (b | c) ? 1'b1 : 1'b0;

endmodule