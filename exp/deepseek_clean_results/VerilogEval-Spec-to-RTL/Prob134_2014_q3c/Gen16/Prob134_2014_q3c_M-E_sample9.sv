module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // LUT format: {next_state_x0, next_state_x1, z_output}
    reg [6:0] fsm_lut [0:4];
    
    initial begin
        // Initialize LUT according to state table
        fsm_lut[0] = {3'b000, 3'b001, 1'b0}; // state 000
        fsm_lut[1] = {3'b001, 3'b100, 1'b0}; // state 001
        fsm_lut[2] = {3'b010, 3'b001, 1'b0}; // state 010
        fsm_lut[3] = {3'b001, 3'b010, 1'b1}; // state 011
        fsm_lut[4] = {3'b011, 3'b100, 1'b1}; // state 100
    end

    // Current state index (0-4)
    wire [2:0] state_index = 
        (y == 3'b000) ? 3'd0 :
        (y == 3'b001) ? 3'd1 :
        (y == 3'b010) ? 3'd2 :
        (y == 3'b011) ? 3'd3 : 3'd4;

    // Get LUT entry
    wire [6:0] lut_entry = fsm_lut[state_index];
    
    // Next state selection
    wire [2:0] next_state = x ? lut_entry[3:1] : lut_entry[6:4];
    
    // Output assignments
    assign Y0 = next_state[0];
    assign z = lut_entry[0];

endmodule