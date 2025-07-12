module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] lower_nibble_pos;
wire [1:0] upper_nibble_pos;
wire       upper_nibble_active;

// Resolve lower nibble (bits 0-3)
assign lower_nibble_pos = in[0] ? 2'd0 :
                          in[1] ? 2'd1 :
                          in[2] ? 2'd2 :
                          in[3] ? 2'd3 :
                          2'd0;

// Resolve upper nibble (bits 4-7)
assign upper_nibble_pos = in[4] ? 2'd0 :
                          in[5] ? 2'd1 :
                          in[6] ? 2'd2 :
                          in[7] ? 2'd3 :
                          2'd0;

// Check if upper nibble has any active bits
assign upper_nibble_active = |in[7:4];

// Final output selection
assign pos = upper_nibble_active ? {1'b1, upper_nibble_pos} : 
                                 {1'b0, lower_nibble_pos};

endmodule