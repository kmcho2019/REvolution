module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Step 1: Create a mask where all bits to the left of first '1' (including the '1') are set
wire [3:0] mask = in | {in[2:0], 1'b0} | {in[1:0], 2'b0} | {in[0], 3'b0};

// Step 2: Isolate just the first '1' by XORing with shifted version
wire [3:0] first_one = mask & ~{mask[2:0], 1'b0};

// Step 3: Simple encoder for the position
assign pos = first_one[0] ? 2'b00 :
             first_one[1] ? 2'b01 :
             first_one[2] ? 2'b10 :
             first_one[3] ? 2'b11 :
                            2'b00;  // default case (all zeros)

endmodule