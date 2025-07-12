module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoding for 6 states
    // bit0 - A, bit1 - B, bit2 - C, bit3 - D, bit4 - E, bit5 - F
    reg [5:0] current_state, next_state;

    // Next state logic using one-hot encoding
    always @(*) begin
        // default no state active
        next_state = 6'b000000;
        casez (current_state)
            6'b000001: // A
                next_state = w ? 6'b000010 : 6'b000001; // B or A
            6'b000010: // B
                next_state = w ? 6'b000100 : 6'b0001000>>1; // C or D
            6'b000100: // C
                next_state = w ? 6'b001000 : 6'b0001000;   // E or D
            6'b001000: // D
                next_state = w ? 6'b010000 : 6'b000001;   // F or A
            6'b010000: // E
                next_state = w ? 6'b010000 : 6'b001000;   // E or D
            6'b100000: // F
                next_state = w ? 6'b000100 : 6'b001000;   // C or D
            default: 
                next_state = 6'b000001; // Reset to A if invalid
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= 6'b000001; // A
        else
            current_state <= next_state;
    end

    // Output logic: z=1 for states E and F (bits 4 or 5)
    assign z = current_state[4] | current_state[5];

endmodule