module TopModule(
    input signed [7:0] a,
    input signed [7:0] b,
    output signed [7:0] s,
    output overflow
);
    // Use built-in addition for optimal PPA
    wire [8:0] sum_ext = {a[7], a} + {b[7], b};
    
    // Extract result and overflow
    assign s = sum_ext[7:0];
    assign overflow = sum_ext[8] ^ sum_ext[7];
endmodule