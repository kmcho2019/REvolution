module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: count of consecutive ones 0..6, plus error state (7)
    typedef enum reg [3:0] {
        S0  = 4'd0, // 0 consecutive ones
        S1  = 4'd1,
        S2  = 4'd2,
        S3  = 4'd3,
        S4  = 4'd4,
        S5  = 4'd5,
        S6  = 4'd6,
        SERR= 4'd7
    } state_t;

    state_t state, next_state;

    // Output signals depend only on the current state and input (Moore outputs)
    reg disc_next, flag_next, err_next;

    // Next state and output logic
    always @(*) begin
        // Default next state and outputs
        next_state = S0;
        disc_next  = 1'b0;
        flag_next  = 1'b0;
        err_next   = 1'b0;

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
                else begin
                    // 5 consecutive ones followed by 0: stuffed zero to discard
                    next_state = S0;
                    disc_next  = 1'b1;
                end
            end
            S6: begin
                if (in)
                    next_state = SERR; // 7 ones → error
                else begin
                    // 6 consecutive ones followed by 0: flag detected
                    next_state = S0;
                    flag_next  = 1'b1;
                end
            end
            SERR: begin
                // Remain in error state until reset
                next_state = SERR;
                err_next   = 1'b1;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic: update state and registered outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule