module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

reg [1:0] lut_next_state [3:0]; // LUT for next state
reg [0:0] lut_out [3:0]; // LUT for output

initial begin
    // Initialize LUT values based on state transition table
    lut_next_state[0] = {2'b01, 2'b00}; // State A: in=1 -> B, in=0 -> A
    lut_next_state[1] = {2'b01, 2'b10}; // State B: in=1 -> B, in=0 -> C
    lut_next_state[2] = {2'b11, 2'b00}; // State C: in=1 -> D, in=0 -> A
    lut_next_state[3] = {2'b01, 2'b10}; // State D: in=1 -> B, in=0 -> C
    
    lut_out[0] = 1'b0; // Output for state A
    lut_out[1] = 1'b0; // Output for state B
    lut_out[2] = 1'b0; // Output for state C
    lut_out[3] = 1'b1; // Output for state D
end

always @(*) begin
    case(state)
        2'b00: begin
            next_state = in ? lut_next_state[0][1:0] : lut_next_state[0][3:2];
            out = lut_out[0];
        end
        2'b01: begin
            next_state = in ? lut_next_state[1][1:0] : lut_next_state[1][3:2];
            out = lut_out[1];
        end
        2'b10: begin
            next_state = in ? lut_next_state[2][1:0] : lut_next_state[2][3:2];
            out = lut_out[2];
        end
        2'b11: begin
            next_state = in ? lut_next_state[3][1:0] : lut_next_state[3][3:2];
            out = lut_out[3];
        end
        default: begin
            next_state = 2'b00; // Default next state A
            out = 1'b0;
        end
    endcase
end

endmodule