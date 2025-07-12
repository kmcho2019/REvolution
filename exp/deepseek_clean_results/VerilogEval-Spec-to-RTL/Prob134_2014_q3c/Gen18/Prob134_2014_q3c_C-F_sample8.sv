module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Compact LUT format: {next_state_x0, next_state_x1}
    reg [5:0] fsm_lut [0:4];
    
    initial begin
        fsm_lut[0] = {3'b000, 3'b001}; // state 000
        fsm_lut[1] = {3'b001, 3'b100}; // state 001
        fsm_lut[2] = {3'b010, 3'b001}; // state 010
        fsm_lut[3] = {3'b001, 3'b010}; // state 011
        fsm_lut[4] = {3'b011, 3'b100}; // state 100
    end

    // Direct state indexing (states are consecutive 0-4)
    wire [2:0] state_index = 
        (y[2] ? (y[1] ? 3'd3 : (y[0] ? 3'd4 : 3'd1)) : 
                (y[1] ? (y[0] ? 3'd3 : 3'd2) : 3'd0));

    // Get LUT entry and select next state
    wire [5:0] lut_entry = fsm_lut[state_index];
    wire [2:0] next_state = x ? lut_entry[2:0] : lut_entry[5:3];
    
    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100);  // Optimized output logic

endmodule