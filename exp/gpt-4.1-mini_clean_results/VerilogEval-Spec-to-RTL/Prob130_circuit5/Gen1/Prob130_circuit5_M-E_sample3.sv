module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [1:0] c_low = c[1:0];
wire c_lt_4 = (c < 4);

wire [3:0] selected_mux;
assign selected_mux = (c_low == 2'b00) ? b :
                      (c_low == 2'b01) ? e :
                      (c_low == 2'b10) ? a :
                                         d;

assign q = c_lt_4 ? selected_mux : 4'hF;

endmodule