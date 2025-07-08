module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
typedef enum reg [2:0] {
    A = 3'd0, // reset state
    B = 3'd1, // output f=1 for one clock cycle after reset de-asserted
    C0 = 3'd2, // wait for x=1 (start pattern)
    C1 = 3'd3, // next x=0
    C2 = 3'd4, // next x=1 (pattern matched)
    D = 3'd5,  // g=1, monitor y for 2 cycles
    E = 3'd6,  // g=1 permanent
    F = 3'd7   // g=0 permanent
} state_t;

reg [2:0] state, next_state;
reg [1:0] y_counter; // count cycles monitoring y in D

// Sequential state update
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic and outputs
always @(*) begin
    // Default outputs
    f = 1'b0;
    g = 1'b0;
    next_state = state;

    case(state)
        A: begin
            // reset asserted, stay here
            // outputs f=0, g=0
            if (resetn)
                next_state = B;
        end

        B: begin
            // output f=1 for one cycle after reset de-asserted
            f = 1'b1;
            g = 1'b0;
            // next move to monitor x pattern start with C0
            next_state = C0;
        end

        C0: begin
            // wait for x=1 to start pattern
            f = 1'b0;
            g = 1'b0;
            if (x == 1'b1)
                next_state = C1;
            else
                next_state = C0;
        end

        C1: begin
            // next x=0
            f = 1'b0;
            g = 1'b0;
            if (x == 1'b0)
                next_state = C2;
            else if (x == 1'b1)
                // pattern failed, restart pattern detection
                next_state = C1; // still waiting for x=0 but got x=1 again, stay?
                // better to restart pattern: go to C1 or C0?
                // The pattern is 1,0,1 - if we get x=1 here, treat as start again
                next_state = C1; // but this could cause infinite loop if x=1 always
                // Safer to go to C0 to wait for fresh start
                next_state = C0;
            else
                next_state = C0; // default back to waiting for x=1
        end

        C2: begin
            // next x=1 to complete pattern
            f = 1'b0;
            g = 1'b0;
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b0)
                // pattern failed, restart pattern detection
                next_state = C0;
            else
                next_state = C0;
        end

        D: begin
            // g=1, monitor y for at most 2 cycles
            f = 1'b0;
            g = 1'b1;
            // y_counter controlled in sequential always block
            // Next state logic based on y and counter is handled in sequential block
            // Here just keep state D, E or F depending on conditions
            // We'll implement y_counter and transitions in sequential block below
            next_state = state; // placeholder, update in sequential logic
        end

        E: begin
            // g=1 permanent
            f = 1'b0;
            g = 1'b1;
            next_state = E;
        end

        F: begin
            // g=0 permanent
            f = 1'b0;
            g = 1'b0;
            next_state = F;
        end

        default: begin
            f = 1'b0;
            g = 1'b0;
            next_state = A;
        end
    endcase
end

// y_counter and transitions from D to E/F managed sequentially
always @(posedge clk) begin
    if (!resetn) begin
        y_counter <= 2'd0;
    end else begin
        if (state == D) begin
            if (y == 1'b1) begin
                // y=1 detected within 2 cycles -> go to E
                y_counter <= 2'd0;
                state <= E; // direct state update to E on posedge clk
            end else begin
                if (y_counter == 2'd1) begin
                    // monitored y for 2 cycles without seeing 1 -> go to F
                    y_counter <= 2'd0;
                    state <= F;
                end else begin
                    y_counter <= y_counter + 1'b1;
                    // keep state D
                end
            end
        end else begin
            y_counter <= 2'd0;
        end
    end
end

// Because we updated state inside sequential block for D->E/F transitions,
// to keep next_state and state consistent, we need to override next_state
// for states E and F when state updated directly.
// So we modify the combinational next_state logic to reflect state register values

always @(*) begin
    if(state == E) begin
        next_state = E;
    end else if(state == F) begin
        next_state = F;
    end
end

endmodule