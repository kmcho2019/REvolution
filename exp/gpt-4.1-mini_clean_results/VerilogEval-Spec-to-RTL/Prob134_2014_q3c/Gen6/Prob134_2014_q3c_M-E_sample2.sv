module TopModule (
    input        clk, // clk unused in this purely combinational approach
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    wire [3:0] nxt_z_vec;

    // Create a 4-bit vector: [3:1] = next state Y[2:0], [0] = output z
    // Indexed by {y,x} = 4-bit index (y[2:0], x)
    assign nxt_z_vec = 
        ( {y,x} == 4'b0000 ) ? {3'b000, 1'b0} : // y=000, x=0
        ( {y,x} == 4'b0001 ) ? {3'b001, 1'b0} : // y=000, x=1
        ( {y,x} == 4'b0010 ) ? {3'b001, 1'b0} : // y=001, x=0
        ( {y,x} == 4'b0011 ) ? {3'b100, 1'b0} : // y=001, x=1
        ( {y,x} == 4'b0100 ) ? {3'b010, 1'b0} : // y=010, x=0
        ( {y,x} == 4'b0101 ) ? {3'b001, 1'b0} : // y=010, x=1
        ( {y,x} == 4'b0110 ) ? {3'b001, 1'b1} : // y=011, x=0
        ( {y,x} == 4'b0111 ) ? {3'b010, 1'b1} : // y=011, x=1
        ( {y,x} == 4'b1000 ) ? {3'b011, 1'b1} : // y=100, x=0
        ( {y,x} == 4'b1001 ) ? {3'b100, 1'b1} : // y=100, x=1
        {3'b000, 1'b0}; // default fallback

    // Y0 is LSB of next state (bit 1 of nxt_z_vec is next_state[0])
    assign Y0 = nxt_z_vec[1];

    // z output from LSB of nxt_z_vec
    assign z  = nxt_z_vec[0];

endmodule