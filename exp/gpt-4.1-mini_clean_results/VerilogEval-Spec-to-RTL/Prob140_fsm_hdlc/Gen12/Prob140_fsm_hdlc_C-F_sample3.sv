module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding
    // Count states 0 to 6: count of consecutive ones
    localparam 
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6;

    // Output states
    localparam 
        SD = 3'd7,  // disc output state (after 5 ones + 0)
        SF = 3'd8,  // flag output state (after 6 ones + 0)
        SE = 3'd9;  // error state (7 or more ones)

    // Use 4 bits for state register (to hold states 0..9)
    reg [3:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            // Counting consecutive ones states
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
                    next_state = SD; // disc output state on zero after 5 ones
            end
            S6: begin
                if (in)
                    next_state = SE; // error state (7+ ones)
                else
                    next_state = SF; // flag output state on zero after 6 ones
            end

            // Output states assert signals for one cycle, then transition on input
            SD: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            SF: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            SE: begin
                // Remain in error state on input=1, else reset count on zero
                if (in)
                    next_state = SE;
                else
                    next_state = S0;
            end

            // Default to safe state on undefined states
            default: next_state = S0;
        endcase
    end

    // State register update on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore outputs depend solely on current state
    assign disc = (state == SD);
    assign flag = (state == SF);
    assign err  = (state == SE);

endmodule