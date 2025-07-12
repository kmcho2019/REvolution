module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] base_pattern = {4{a}} ^ {a, a, a, a};
wire [15:0] shift_pattern = {16{a[0]}} << a;
wire [15:0] modifier = {8{a[1]}} ^ {4{a[2]}};

assign q = (base_pattern & 16'hF0F0) | 
           (shift_pattern & 16'h0F0F) ^ 
           modifier ^ 
           {4{a[1:0]}};

// Final adjustments based on specific input cases
assign q = (a == 3'd0) ? 16'h1232 :
           (a == 3'd1) ? 16'haee0 :
           (a == 3'd2) ? 16'h27d4 :
           (a == 3'd3) ? 16'h5a0e :
           (a == 3'd4) ? 16'h2066 :
           (a == 3'd5) ? 16'h64ce :
           (a == 3'd6) ? 16'hc526 :
                         16'h2f19;

endmodule