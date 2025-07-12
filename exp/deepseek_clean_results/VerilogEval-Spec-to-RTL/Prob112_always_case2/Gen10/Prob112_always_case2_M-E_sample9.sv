module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Process lower 2 bits (group 0)
    wire group0_valid = |in[1:0];
    wire [1:0] group0_pos = in[0] ? 2'b00 : 2'b01;

    // Process upper 2 bits (group 1)
    wire group1_valid = |in[3:2];
    wire [1:0] group1_pos = in[2] ? 2'b10 : 2'b11;

    // Final selection
    assign pos = group0_valid ? group0_pos : 
                (group1_valid ? group1_pos : 2'b00);

endmodule