module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Mux implementation
    wire [1:0] sel = {a, b};
    wire [3:0] mux_in;
    
    assign mux_in[0] = 0;          // a=0, b=0 case
    assign mux_in[1] = c | d;      // a=0, b=1 case
    assign mux_in[2] = c | d;      // a=1, b=0 case
    assign mux_in[3] = c | d;      // a=1, b=1 case
    
    assign q = mux_in[sel];
endmodule