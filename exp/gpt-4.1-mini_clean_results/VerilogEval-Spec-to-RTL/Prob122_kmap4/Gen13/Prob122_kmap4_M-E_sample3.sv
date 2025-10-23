module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire mux1_out, mux2_out;

    // First mux: select between 0 and 1 based on b
    wire mux1_0 = 0;
    wire mux1_1 = 1;
    assign mux1_out = b ? mux1_1 : mux1_0;  // mux with select b: out = b

    // Second mux: select between 1 and 0 based on a
    wire mux2_0 = 1;
    wire mux2_1 = 0;
    assign mux2_out = a ? mux2_1 : mux2_0;  // mux with select a: out = ~a

    // Use c and d to choose between mux1_out and mux2_out via XOR
    assign out = (c ^ d) ? mux2_out : mux1_out;

endmodule