module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding: only one bit set at a time
    // state bits: [A B C D]
    reg [3:0] state, next_state;

    // Synchronous reset and state register
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // state A active
        else
            state <= next_state;
    end

    // Decode state bits for readability
    wire state_A = state[0];
    wire state_B = state[1];
    wire state_C = state[2];
    wire state_D = state[3];

    // Next state logic
    always @(*) begin
        // Default stay in current state
        next_state = 4'b0000;
        if (state_A) begin
            // Priority: r[0] > r[1] > r[2]
            if (r[0])
                next_state = 4'b0010; // B
            else if (r[1])
                next_state = 4'b0100; // C
            else if (r[2])
                next_state = 4'b1000; // D
            else
                next_state = 4'b0001; // A
        end
        else if (state_B) begin
            next_state = r[0] ? 4'b0010 : 4'b0001; // Stay B if r0, else A
        end
        else if (state_C) begin
            next_state = r[1] ? 4'b0100 : 4'b0001; // Stay C if r1, else A
        end
        else if (state_D) begin
            next_state = r[2] ? 4'b1000 : 4'b0001; // Stay D if r2, else A
        end
        else begin
            // Should not occur; default to A
            next_state = 4'b0001;
        end
    end

    // Output grants directly from states B, C, D bits
    assign g = {state_D, state_C, state_B};

endmodule