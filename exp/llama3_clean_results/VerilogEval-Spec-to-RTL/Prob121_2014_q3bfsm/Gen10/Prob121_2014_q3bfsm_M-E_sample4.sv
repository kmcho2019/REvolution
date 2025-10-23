module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state

// Lookup table for next states
reg [2:0] next_states [8]; // 2^3 (for 3-bit state)

initial begin
    // Initialize LUT with next states based on the given state transition table
    next_states[0] = 3'b000; // State 000, x=0
    next_states[1] = 3'b001; // State 000, x=1
    next_states[2] = 3'b001; // State 001, x=0
    next_states[3] = 3'b100; // State 001, x=1
    next_states[4] = 3'b010; // State 010, x=0
    next_states[5] = 3'b001; // State 010, x=1
    next_states[6] = 3'b001; // State 011, x=0
    next_states[7] = 3'b010; // State 011, x=1
    next_states[8] = 3'b011; // State 100, x=0 (Note: This index is out of bounds for 3-bit state, adjust accordingly)
    next_states[9] = 3'b100; // State 100, x=1 (Note: This index is out of bounds for 3-bit state, adjust accordingly)
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        // Compute next state index based on current state and input
        reg [2:0] next_state_index;
        if (x) begin
            case (y)
                3'b000: next_state_index = 3'b001;
                3'b001: next_state_index = 3'b100;
                3'b010: next_state_index = 3'b001;
                3'b011: next_state_index = 3'b010;
                3'b100: next_state_index = 3'b100;
                default: next_state_index = 3'b000;
            endcase
        end else begin
            case (y)
                3'b000: next_state_index = 3'b000;
                3'b001: next_state_index = 3'b001;
                3'b010: next_state_index = 3'b010;
                3'b011: next_state_index = 3'b001;
                3'b100: next_state_index = 3'b011;
                default: next_state_index = 3'b000;
            endcase
        end
        y <= next_state_index;
    end
end

// Simplified output logic
always @(*) begin
    case (y)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule