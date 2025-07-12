module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot encoding for 4 states: A=0001, B=0010, C=0100, D=1000
    reg [3:0] state, next_state;

    // Next-state logic as combinational equations
    // From the state transition table:
    // A: next A = (in==0), next B = (in==1)
    // B: next C = (in==0), next B = (in==1)
    // C: next A = (in==0), next D = (in==1)
    // D: next C = (in==0), next B = (in==1)

    always @(*) begin
        // Default all 0
        next_state = 4'b0000;

        // State A is state[0]
        if (state[0]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // A
            else            next_state[1] = 1'b1; // B
        end
        // State B is state[1]
        else if (state[1]) begin
            if (in == 1'b0) next_state[2] = 1'b1; // C
            else            next_state[1] = 1'b1; // B
        end
        // State C is state[2]
        else if (state[2]) begin
            if (in == 1'b0) next_state[0] = 1'b1; // A
            else            next_state[3] = 1'b1; // D
        end
        // State D is state[3]
        else if (state[3]) begin
            if (in == 1'b0) next_state[2] = 1'b1; // C
            else            next_state[1] = 1'b1; // B
        end
        else begin
            // In case of invalid state (e.g., after reset glitch), default to A
            next_state[0] = 1'b1;
        end
    end

    // Sequential logic for state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001; // reset to state A
        else
            state <= next_state;
    end

    // Output is high only in state D (state[3])
    assign out = state[3];

endmodule