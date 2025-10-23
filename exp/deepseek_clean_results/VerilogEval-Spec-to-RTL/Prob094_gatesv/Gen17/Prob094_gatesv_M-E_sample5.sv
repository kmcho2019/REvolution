module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create neighbor vectors
    wire [3:0] left_neighbor  = {in[0], in[3:1]};  // Circular left shift
    wire [3:0] right_neighbor = {in[2:0], in[3]};  // Circular right shift
    
    // out_both: current AND left neighbor (ignore MSB)
    assign out_both = {1'b0, in[2:0] & left_neighbor[2:0]};
    
    // out_any: current OR right neighbor (ignore LSB)
    assign out_any = {in[3:1] | right_neighbor[3:1], 1'b0};
    
    // out_different: current XOR left neighbor (full circular)
    assign out_different = in ^ left_neighbor;

endmodule