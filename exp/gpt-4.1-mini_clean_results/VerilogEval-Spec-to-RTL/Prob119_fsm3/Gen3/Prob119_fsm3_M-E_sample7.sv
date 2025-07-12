module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    // state[3] = D, state[2] = C, state[1] = B, state[0] = A
    reg [3:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        // Default no states active
        next_state = 4'b0000;

        // State A logic
        if (state[0]) begin
            if (in == 1'b0)
                next_state = 4'b0001; // stay in A
            else
                next_state = 4'b0010; // go to B
        end
        // State B logic
        else if (state[1]) begin
            if (in == 1'b0)
                next_state = 4'b0100; // go to C
            else
                next_state = 4'b0010; // stay in B
        end
        // State C logic
        else if (state[2]) begin
            if (in == 1'b0)
                next_state = 4'b0001; // go to A
            else
                next_state = 4'b1000; // go to D
        end
        // State D logic
        else if (state[3]) begin
            if (in == 1'b0)
                next_state = 4'b0100; // go to C
            else
                next_state = 4'b0010; // go to B
        end
        else begin
            // Safety: If no state is active, reset to A
            next_state = 4'b0001;
        end
    end

    // State register with asynchronous active high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 4'b0001; // reset to A
        else
            state <= next_state;
    end

    // Moore output logic: output is 1 only in state D (state[3])
    always @(*) begin
        out = state[3];
    end

endmodule