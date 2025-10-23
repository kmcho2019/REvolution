module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: only bits [2:0] are meaningful
    assign out_both[2:0] = in[2:0] & in[3:1];
    
    // out_any: only bits [3:1] are meaningful
    assign out_any[3:1] = in[3:1] | in[2:0];
    
    // out_different: optimized XOR implementation
    wire [3:0] rotated_in = {in[0], in[3:1]};
    assign out_different = in ^ rotated_in;

endmodule