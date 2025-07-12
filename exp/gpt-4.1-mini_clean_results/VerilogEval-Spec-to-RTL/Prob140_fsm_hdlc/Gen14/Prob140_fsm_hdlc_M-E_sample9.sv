module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding
    typedef enum logic [3:0] {
        S0  = 4'd0,  // 0 consecutive ones
        S1  = 4'd1,  // 1 consecutive one
        S2  = 4'd2,  // 2 consecutive ones
        S3  = 4'd3,  // 3 consecutive ones
        S4  = 4'd4,  // 4 consecutive ones
        S5  = 4'd5,  // 5 consecutive ones
        S6  = 4'd6,  // 6 consecutive ones
        DISC_STATE = 4'd7,  // disc output state (after 5 ones + 0)
        FLAG_STATE = 4'd8,  // flag output state (after 6 ones + 0)
        ERR_STATE  = 4'd9   // error state (7 or more ones)
    } state_t;

    state_t state, next_state;

    // Next state logic: pure combinational
    always @(*) begin
        case (state)
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
                    // 5 consecutive ones + 0 detected -> discard next bit
                    next_state = DISC_STATE;
            end

            S6: begin
                if (in)
                    // 7 or more consecutive ones => error
                    next_state = ERR_STATE;
                else
                    // 6 consecutive ones + 0 detected -> flag next bit
                    next_state = FLAG_STATE;
            end

            DISC_STATE: begin
                // After disc output, restart counting from current input
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            FLAG_STATE: begin
                // After flag output, restart counting from current input
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            ERR_STATE: begin
                // Remain in error state if ones continue
                if (in)
                    next_state = ERR_STATE;
                else
                    // Reset counting after error sequence ends
                    next_state = S0;
            end

            default: begin
                next_state = S0; // safe default
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Outputs are Moore-type, asserted one cycle after detection
    assign disc = (state == DISC_STATE);
    assign flag = (state == FLAG_STATE);
    assign err  = (state == ERR_STATE);

endmodule