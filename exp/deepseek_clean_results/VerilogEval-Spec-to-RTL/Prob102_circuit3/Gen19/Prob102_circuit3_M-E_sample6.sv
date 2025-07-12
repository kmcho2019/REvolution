module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [1:0] sel = {a, b};
    wire [3:0] mux_in;

    assign mux_in[0] = 0;          // When a=0, b=0
    assign mux_in[1] = c | d;      // When a=0, b=1
    assign mux_in[2] = c | d;      // When a=1, b=0
    assign mux_in[3] = c | d;      // When a=1, b=1

    assign q = mux_in[sel];

endmodule