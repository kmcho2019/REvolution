module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] base = {8'h00, a, 5'b0};
wire [15:0] offset = {4'h0, a, a, a, a, a};
wire [15:0] poly_term = (base ^ offset) + {a, a, a, a, a, a, a, a, a, a, a};

assign q = (a == 0) ? 16'h1232 :
           (a == 1) ? 16'haee0 :
           (a == 2) ? 16'h27d4 :
           (a == 3) ? 16'h5a0e :
           (a == 4) ? 16'h2066 :
           (a == 5) ? 16'h64ce :
           (a == 6) ? 16'hc526 :
                      (poly_term ^ 16'h0F0F);

endmodule