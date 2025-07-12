module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding for states
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic
    always @(*) begin
        // Default next_state to all zeros to avoid inferred latches
        next_state = 6'b000000;
        if (state == A) begin
            if (w)
                next_state = B;
            else
                next_state = A;
        end
        else if (state == B) begin
            if (w)
                next_state = C;
            else
                next_state = D;
        end
        else if (state == C) begin
            if (w)
                next_state = E;
            else
                next_state = D;
        end
        else if (state == D) begin
            if (w)
                next_state = F;
            else
                next_state = A;
        end
        else if (state == E) begin
            if (w)
                next_state = E;
            else
                next_state = D;
        end
        else if (state == F) begin
            if (w)
                next_state = C;
            else
                next_state = D;
        end
        else begin
            // Should not occur - reset to state A if invalid state detected
            next_state = A;
        end
    end

    // Output logic: z = 1 when in state E or F
    assign z = state[4] | state[5]; // E = bit4, F = bit5

endmodule