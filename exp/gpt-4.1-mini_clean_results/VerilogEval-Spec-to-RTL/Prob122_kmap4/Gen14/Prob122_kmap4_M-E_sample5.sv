module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire mux1_out, mux2_out;

    // First level MUX based on b selects between c and d
    assign mux1_out = b ? d : c;

    // Second level MUX based on c selects between a and b
    assign mux2_out = c ? b : a;

    // Final output is XOR of the two mux outputs
    assign out = mux1_out ^ mux2_out;
endmodule