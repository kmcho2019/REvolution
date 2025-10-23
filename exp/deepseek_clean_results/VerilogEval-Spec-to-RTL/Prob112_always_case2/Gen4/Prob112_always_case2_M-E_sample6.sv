module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Create a mask that propagates the first '1' found
    wire [3:0] mask = {in[3] | in[2] | in[1] | in[0],
                       in[3] | in[2] | in[1],
                       in[3] | in[2],
                       in[3]};
    
    // Isolate the first '1' position
    wire [3:0] first_one = in & ~{mask[2:0], 1'b0};
    
    // Convert one-hot to binary
    assign pos[1] = first_one[3] | first_one[2];
    assign pos[0] = first_one[3] | first_one[1];
    
    // Handle all-zero case
    assign pos = (|in) ? pos : 2'b00;

endmodule