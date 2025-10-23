module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire [1:0] cd = {c, d};
wire [3:0] mux_in;

// Implement each case as separate simple logic
assign mux_in[0] = ~(a & b);  // cd = 00
assign mux_in[1] = ~b;        // cd = 01
assign mux_in[2] = a | b;     // cd = 11
assign mux_in[3] = ~a;        // cd = 10

// Final 4:1 mux
assign out = (cd == 2'b00) ? mux_in[0] :
             (cd == 2'b01) ? mux_in[1] :
             (cd == 2'b11) ? mux_in[2] :
             mux_in[3];

endmodule