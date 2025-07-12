module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    // Directly encode position by priority from MSB to LSB
    assign pos = in[3] ? 2'd3 :
                 in[2] ? 2'd2 :
                 in[1] ? 2'd1 :
                 in[0] ? 2'd0 :
                 2'd0; // default output if no bits set
endmodule