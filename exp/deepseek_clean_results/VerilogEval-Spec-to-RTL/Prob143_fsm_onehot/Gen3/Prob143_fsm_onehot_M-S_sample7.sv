module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    next_state = 10'b0;
    
    // Handle regular states (S0-S4) with common pattern
    if (|state[4:0]) begin
        next_state[0] = ~in;
        if (in) begin
            casez (state[4:0])
                5'b00001: next_state[1] = 1;
                5'b00010: next_state[2] = 1;
                5'b00100: next_state[3] = 1;
                5'b01000: next_state[4] = 1;
                5'b10000: next_state[5] = 1;
            endcase
        end
    end
    
    // Handle special states (S5-S9)
    if (state[5]) begin
        next_state[in ? 6 : 8] = 1;
    end
    if (state[6]) begin
        next_state[in ? 7 : 9] = 1;
    end
    if (state[7]) begin
        next_state[in ? 7 : 0] = 1;
    end
    if (state[8] | state[9]) begin
        next_state[0] = next_state[0] | ~in;
        next_state[1] = next_state[1] | in;
    end
end

// Simplified output logic
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

endmodule