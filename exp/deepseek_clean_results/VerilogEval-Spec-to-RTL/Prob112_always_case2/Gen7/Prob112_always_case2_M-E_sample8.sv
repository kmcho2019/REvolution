module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// First level: Process each 2-bit group independently
wire [1:0] group0_enc = {in[1], in[0]};
wire [1:0] group1_enc = {in[3], in[2]};

// Second level: Encode each group's highest priority '1'
wire [1:0] group0_pos = (group0_enc[1]) ? 2'b01 : 
                       (group0_enc[0]) ? 2'b00 : 2'b10;

wire [1:0] group1_pos = (group1_enc[1]) ? 2'b01 : 
                       (group1_enc[0]) ? 2'b00 : 2'b10;

// Third level: Combine results based on group priority
assign pos = (|group1_enc) ? {1'b1, group1_pos[0]} :  // MSB group has priority
             (|group0_enc) ? {1'b0, group0_pos[0]} :  // LSB group
             2'b00;                                   // All zeros case

endmodule