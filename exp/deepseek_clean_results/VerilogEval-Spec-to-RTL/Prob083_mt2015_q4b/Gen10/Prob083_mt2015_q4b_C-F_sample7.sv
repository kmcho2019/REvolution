module TopModule (
    input x,
    input y,
    output reg z
);
    // State definition
    typedef enum logic {SAME, DIFF} state_t;
    state_t current_state;

    always @(*) begin
        // Compute equality once
        if (x == y) begin
            current_state = SAME;
            z = 1'b1;
        end
        else begin
            current_state = DIFF;
            z = 1'b0;
        end
    end

    // Initial state (matches waveform where z=1 at time 0)
    initial begin
        current_state = SAME;
        z = 1'b1;
    end
endmodule