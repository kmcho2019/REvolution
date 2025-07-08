module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

// State encoding
localparam S0    = 3'd0; // 0 consecutive 1s
localparam S1    = 3'd1; // 1 consecutive 1
localparam S2    = 3'd2; // 2 consecutive 1s
localparam S3    = 3'd3; // 3 consecutive 1s
localparam S4    = 3'd4; // 4 consecutive 1s
localparam S5    = 3'd5; // 5 consecutive 1s
localparam S6    = 3'd6; // 6 consecutive 1s
localparam S_ERR = 3'd7; // error state

reg [2:0] state, next_state;

// Next state logic
always @(*) begin
    case(state)
        S0: begin
            if (in)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (in)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (in)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (in)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (in)
                next_state = S5;
            else
                next_state = S0;
        end
        S5: begin
            if (in)
                next_state = S6;
            else
                next_state = S0;
        end
        S6: begin
            if (in)
                next_state = S_ERR;
            else
                next_state = S0;
        end
        S_ERR: begin
            // Stay in error state until reset
            next_state = S_ERR;
        end
        default: next_state = S0;
    endcase
end

// State register with synchronous active-high reset
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Output logic: Moore type outputs depend only on the current state (state after clock)
// Outputs are asserted for one cycle after the condition is detected.
// According to problem, outputs are asserted beginning on the cycle after the pattern occurs,
// so the outputs reflect the current FSM state.
always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        // Default outputs
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;

        case(state)
            // disc asserted when previous input was 0 after seeing 5 consecutive ones,
            // so disc is asserted in state S0 if last transition was from S5 and input=0
            // But since outputs depend only on current state, and state is updated at posedge clk,
            // the disc output must be asserted in S0 when last input triggered disc.
            // But S0 is ambiguous (also normal state).
            //
            // To solve this, outputs depend only on state.
            // The problem states outputs are asserted for one cycle starting on the cycle after condition.
            // So we encode disc in state S0 if the last transition was from S5 by checking input.
            //
            // But Moore FSM outputs depend only on state.
            //
            // So we must signal disc output in S0 only if last input caused disc.
            //
            // To do this, we can add a flag register that remembers if disc is to be asserted.
            //
            // Similarly for flag (state S0 after transition from S6 and input=0).
            //
            // So let's store outputs in combinational logic using last state and input.
            //
            // Alternate solution:
            // Use a registered output enable signals set in the combinational always block with previous state and input.
            //
            // We'll create output logic combinationally from previous state and current input.
            //
            // Let's create output signals combinationally from 'state' and 'in' (previous input):
            // But at posedge clk we only know current state and input.
            //
            // Another approach:
            // Since outputs are asserted the cycle after the pattern occurs, outputs must be generated from previous state and current input.
            //
            // So we add a register to hold previous state and input, then outputs are registered from that.
        endcase
    end
end

// To implement outputs correctly, we need to register previous state and previous input,
// then outputs are generated from that in a Moore style, asserted for one cycle after detection.

reg [2:0] prev_state;
reg       prev_in;

always @(posedge clk) begin
    if (reset) begin
        prev_state <= S0;
        prev_in <= 1'b0;
    end else begin
        prev_state <= state;
        prev_in <= in;
    end
end

always @(posedge clk) begin
    if (reset) begin
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;
    end else begin
        // Clear outputs by default
        disc <= 1'b0;
        flag <= 1'b0;
        err  <= 1'b0;

        // disc: discarding bit after 5 consecutive 1s followed by 0 (pattern 0111110)
        if (prev_state == S5 && prev_in == 1'b0)
            disc <= 1'b1;

        // flag: flag detected after 6 consecutive 1s followed by 0 (01111110)
        if (prev_state == S6 && prev_in == 1'b0)
            flag <= 1'b1;

        // err: in error state (7 or more consecutive 1s)
        if (state == S_ERR)
            err <= 1'b1;
    end
end

endmodule