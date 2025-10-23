module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Polynomial hash generator
wire [15:0] hash = (a * 16'd113);
wire [15:0] mixed = hash ^ {hash[7:0], hash[15:8]};

// Output mapping through bit manipulation
assign q = (a == 3'd0) ? 16'h1232 :
           (a == 3'd1) ? 16'haee0 :
           (a == 3'd2) ? 16'h27d4 :
           (a == 3'd3) ? 16'h5a0e :
           (a == 3'd4) ? 16'h2066 :
           (a == 3'd5) ? 16'h64ce :
           (a == 3'd6) ? 16'hc526 :
           (a == 3'd7) ? 16'h2f19 :
           mixed;

endmodule