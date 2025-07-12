module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // Define states indicating consecutive number of ones (0 to 6), plus error state
    typedef enum reg [3:0] {
        S0 = 4'd0, // No consecutive ones
        S1 = 4'd1, // 1 consecutive one
        S2 = 4'd2, // 2 consecutive ones
        S3 = 4'd3, // 3 consecutive ones
        S4 = 4'd4, // 4 consecutive ones
        S5 = 4'd5, // 5 consecutive ones
        S6 = 4'd6, // 6 consecutive ones
        S7 = 4'd7  // Error state: 7 or more consecutive ones
    } state_t;

    state_t state, next_state;

    // Output signals registered, depend only on current state and input in the previous cycle
    reg disc_d, flag_d, err_d;

    // Next state logic
    always @(*) begin
        disc_d = 1'b0;
        flag_d = 1'b0;
        err_d  = 1'b0;
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
                if (in) begin
                    next_state = S6;
                end else begin
                    next_state = S0;
                    disc_d = 1'b1; // 5 consecutive ones then zero -> discard bit next cycle
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7; // error state, 7 or more ones
                    err_d = 1'b1;
                end else begin
                    next_state = S0;
                    flag_d = 1'b1; // 6 consecutive ones then zero -> flag next cycle
                end
            end
            S7: begin
                if (in) begin
                    next_state = S7; // stay in error state as long as ones continue
                    err_d = 1'b1;
                end else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // State and output registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_d;
            flag  <= flag_d;
            err   <= err_d;
        end
    end

endmodule