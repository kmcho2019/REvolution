module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);
    // One-hot state encoding: each state is a separate bit
    // state vector: [D C B A]
    reg [3:0] state, next_state;

    // Combinational logic for next state generation
    always @(*) begin
        // Default: deassert all states
        next_state = 4'b0000;

        // State A logic
        if (state[0]) begin // A
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b0010; // B
        end
        // State B logic
        else if (state[1]) begin // B
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
        end
        // State C logic
        else if (state[2]) begin // C
            if (in == 1'b0)
                next_state = 4'b0001; // A
            else
                next_state = 4'b1000; // D
        end
        // State D logic
        else if (state[3]) begin // D
            if (in == 1'b0)
                next_state = 4'b0100; // C
            else
                next_state = 4'b0010; // B
        end
        else begin
            // Safety fallback: go to A
            next_state = 4'b0001;
        end
    end

    // Sequential state register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 4'b0001; // Reset to A
        else
            state <= next_state;
    end

    // Moore output logic: output is 1 only in state D
    always @(*) begin
        out = state[3];
    end
endmodule