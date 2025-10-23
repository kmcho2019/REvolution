module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Parallel prefix OR to create thermometer mask
wire [7:0] prefix_or;
assign prefix_or[0] = in[0];
assign prefix_or[1] = in[1] | prefix_or[0];
assign prefix_or[2] = in[2] | prefix_or[1];
assign prefix_or[3] = in[3] | prefix_or[2];
assign prefix_or[4] = in[4] | prefix_or[3];
assign prefix_or[5] = in[5] | prefix_or[4];
assign prefix_or[6] = in[6] | prefix_or[5];
assign prefix_or[7] = in[7] | prefix_or[6];

// Isolate first set bit by XOR with shifted version
wire [7:0] first_bit = prefix_or ^ {1'b0, prefix_or[7:1]};

// Binary encoder for one-hot to binary conversion
assign pos = first_bit[0] ? 3'd0 :
             first_bit[1] ? 3'd1 :
             first_bit[2] ? 3'd2 :
             first_bit[3] ? 3'd3 :
             first_bit[4] ? 3'd4 :
             first_bit[5] ? 3'd5 :
             first_bit[6] ? 3'd6 :
             first_bit[7] ? 3'd7 : 3'd0;

endmodule