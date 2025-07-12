module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

// First stage: Select high 4 bits (or groups of 4 bits)
wire [3:0] high_bits;
assign high_bits = (sel < 9) ? {a[15], b[15], c[15], d[15], e[15], f[15], g[15], h[15], i[15]}[sel] ? 4'b1111 : 4'b0000 : 4'b1111;

// Second stage: Select low 4 bits (or groups of 4 bits)
wire [3:0] low_bits;
assign low_bits = (sel < 9) ? {a[11], b[11], c[11], d[11], e[11], f[11], g[11], h[11], i[11]}[sel] ? 4'b1111 : 4'b0000 : 4'b1111;

// Combine high and low bits to form the output
assign out = (sel < 9) ? 
    { 
        (sel == 0) ? a[15:12] : 
        (sel == 1) ? b[15:12] : 
        (sel == 2) ? c[15:12] : 
        (sel == 3) ? d[15:12] : 
        (sel == 4) ? e[15:12] : 
        (sel == 5) ? f[15:12] : 
        (sel == 6) ? g[15:12] : 
        (sel == 7) ? h[15:12] : 
        (sel == 8) ? i[15:12] : 4'b1111,
        
        (sel == 0) ? a[11:8] : 
        (sel == 1) ? b[11:8] : 
        (sel == 2) ? c[11:8] : 
        (sel == 3) ? d[11:8] : 
        (sel == 4) ? e[11:8] : 
        (sel == 5) ? f[11:8] : 
        (sel == 6) ? g[11:8] : 
        (sel == 7) ? h[11:8] : 
        (sel == 8) ? i[11:8] : 4'b1111,
        
        (sel == 0) ? a[7:4] : 
        (sel == 1) ? b[7:4] : 
        (sel == 2) ? c[7:4] : 
        (sel == 3) ? d[7:4] : 
        (sel == 4) ? e[7:4] : 
        (sel == 5) ? f[7:4] : 
        (sel == 6) ? g[7:4] : 
        (sel == 7) ? h[7:4] : 
        (sel == 8) ? i[7:4] : 4'b1111,
        
        (sel == 0) ? a[3:0] : 
        (sel == 1) ? b[3:0] : 
        (sel == 2) ? c[3:0] : 
        (sel == 3) ? d[3:0] : 
        (sel == 4) ? e[3:0] : 
        (sel == 5) ? f[3:0] : 
        (sel == 6) ? g[3:0] : 
        (sel == 7) ? h[3:0] : 
        (sel == 8) ? i[3:0] : 4'b1111
    } : 16'b1111111111111111;

endmodule