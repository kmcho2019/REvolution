module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum_ext;  // Extended sum to include carry-out
    
    // Simple ripple-carry addition
    assign sum_ext = {1'b0, a} + {1'b0, b};
    assign s = sum_ext[7:0];
    
    // Overflow detection (same as before)
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule