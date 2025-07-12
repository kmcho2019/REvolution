module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Circular left shift for neighbor to the left (wrap-around)
    wire [3:0] in_left = {in[2:0], 1'b0};
    // Circular right shift for neighbor to the right (wrap-around)
    wire [3:0] in_right = {1'b0, in[3:1]};
    // Circular left shift with wrap-around for out_different neighbor
    wire [3:0] in_left_wrap = {in[2:0], in[3]};

    // out_both[i] = in[i] & in[i+1] for i=0..2, out_both[3] = 0
    assign out_both = in & in_left;
    
    // out_any[i] = in[i] | in[i-1] for i=1..3, out_any[0] = 0
    assign out_any = in | in_right;

    // Clear out_both[3] and out_any[0] where no valid neighbor exists
    assign out_both[3] = 1'b0;
    assign out_any[0]  = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 4]; wrap-around
    assign out_different = in ^ in_left_wrap;

endmodule