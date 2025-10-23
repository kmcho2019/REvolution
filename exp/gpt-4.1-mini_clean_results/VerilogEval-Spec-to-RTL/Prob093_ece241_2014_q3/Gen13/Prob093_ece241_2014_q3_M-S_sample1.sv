module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    wire mux0 = c | d;      // ab=00 column
    wire mux1 = 1'b0;       // ab=01 column
    wire mux2 = c & d;      // ab=11 column
    wire mux3 = c | ~d;     // ab=10 column

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule