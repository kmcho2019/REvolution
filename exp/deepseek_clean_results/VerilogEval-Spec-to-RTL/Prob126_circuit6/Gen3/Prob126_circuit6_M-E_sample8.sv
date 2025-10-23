module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] base = {4{a}};
wire [15:0] shifted = base << a;
wire [15:0] xored = shifted ^ 16'h1232;
wire [15:0] rotated = {xored[7:0], xored[15:8]};
wire [15:0] adjusted = rotated + {8'h00, a, 5'h00};

assign q = (a == 3'd0) ? 16'h1232 :
           (a == 3'd1) ? 16'haee0 :
           (a == 3'd2) ? 16'h27d4 :
           (a == 3'd3) ? 16'h5a0e :
           (a == 3'd4) ? 16'h2066 :
           (a == 3'd5) ? 16'h64ce :
           (a == 3'd6) ? 16'hc526 :
           (a == 3'd7) ? 16'h2f19 :
           16'h0000;

// Alternative algorithmic implementation (commented out as it doesn't match all cases)
// assign q = (({a, 13'h000} ^ {4{a}}) + {8'h00, a, a, 3'h0}) ^ 16'h1232;

endmodule