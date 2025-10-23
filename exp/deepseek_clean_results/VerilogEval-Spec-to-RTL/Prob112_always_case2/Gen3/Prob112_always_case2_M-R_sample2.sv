module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Upper pair (bits 3 and 2)
    wire upper_pair_active = in[3] | in[2];
    wire upper_pair_pos = in[3] ? 1'b1 : 1'b0;  // 1 for bit3, 0 for bit2
    
    // Lower pair (bits 1 and 0)
    wire lower_pair_active = in[1] | in[0];
    wire lower_pair_pos = in[1] ? 1'b1 : 1'b0;  // 1 for bit1, 0 for bit0
    
    // Final position calculation
    wire [1:0] intermediate_pos;
    assign intermediate_pos[1] = upper_pair_active;
    assign intermediate_pos[0] = upper_pair_active ? upper_pair_pos : lower_pair_pos;
    
    // Output with all-zeros handling
    assign pos = (|in) ? intermediate_pos : 2'b00;

endmodule