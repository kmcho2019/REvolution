module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states representing count of consecutive ones seen
    typedef enum logic [3:0] {
        S0 = 4'd0, // zero consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        S7 = 4'd7  // 7 or more consecutive ones (error state)
    } state_t;

    state_t state, next_state;

    // Next state logic and output logic
    always @(*) begin
        // Default outputs
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case(state)
            S0: begin
                if (in == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (in == 1'b1)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in == 1'b1)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in == 1'b1)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in == 1'b1)
                    next_state = S6;
                else begin
                    // Zero after 5 ones - discard bit detected
                    next_state = S0;
                    disc = 1'b1;  // output disc next cycle (Moore)
                end
            end
            S6: begin
                if (in == 1'b1)
                    next_state = S7;
                else begin
                    // Zero after 6 ones - flag detected
                    next_state = S0;
                    flag = 1'b1; // output flag next cycle
                end
            end
            S7: begin
                if (in == 1'b1)
                    next_state = S7; // stay in error state
                else
                    next_state = S0;
                // error in S7 or more consecutive ones
                err = 1'b1;
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Output registers and state update on positive clock edge with synchronous reset
    // We need outputs asserted for full cycle after detection,
    // so outputs depend on previous state and input combination.
    // To achieve this, we register outputs on clock edge.

    reg disc_r, flag_r, err_r;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r  <= 1'b0;
        end else begin
            state <= next_state;
            disc_r <= disc;
            flag_r <= flag;
            err_r  <= err;
        end
    end

    // Assign registered outputs
    always @(*) begin
        disc = disc_r;
        flag = flag_r;
        err  = err_r;
    end

endmodule