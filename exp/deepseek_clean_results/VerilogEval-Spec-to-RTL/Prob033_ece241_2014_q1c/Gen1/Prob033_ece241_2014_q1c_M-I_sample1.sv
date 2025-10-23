module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum_ext;
    
    // Perform the addition with extended bit for carry
    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];
    
    // Optimized overflow detection using carry-in/out method
    assign overflow = (a[7] ^ b[7]) ? 1'b0 : (a[7] ^ sum_ext[7]);
endmodule