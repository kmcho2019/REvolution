module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] base = 16'h1232;  // Base pattern for input 0
wire [15:0] mask1 = 16'h9DCE; // Transformation mask 1
wire [15:0] mask2 = 16'h35A2; // Transformation mask 2
wire [15:0] mask3 = 16'h47DC; // Transformation mask 3

// Compute output through logical transformations
assign q = base ^ 
           ({16{a[0]}} & mask1) ^ 
           ({16{a[1]}} & (mask2 << a)) ^ 
           ({16{a[2]}} & (mask3 >> a));

endmodule