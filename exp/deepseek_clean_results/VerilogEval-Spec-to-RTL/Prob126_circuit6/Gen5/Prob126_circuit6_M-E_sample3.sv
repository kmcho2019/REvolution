module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] shifted_a = {13'b0, a};  // 3-bit input extended to 16 bits
wire [15:0] intermediate;

// First transformation layer
assign intermediate = (shifted_a << 8) ^ 
                     (shifted_a << 4) ^ 
                     (shifted_a << 2) ^ 
                     (shifted_a << 1);

// Final transformation with unique constants for each case
assign q = (a == 3'd0) ? (intermediate ^ 16'h1232) :
           (a == 3'd1) ? (intermediate ^ 16'h4cc2) :
           (a == 3'd2) ? (intermediate ^ 16'h35e0) :
           (a == 3'd3) ? (intermediate ^ 16'h481a) :
           (a == 3'd4) ? (intermediate ^ 16'h2054) :
           (a == 3'd5) ? (intermediate ^ 16'h64fc) :
           (a == 3'd6) ? (intermediate ^ 16'hc534) :
           (a == 3'd7) ? (intermediate ^ 16'h2f1b) :
           16'h0000;

endmodule