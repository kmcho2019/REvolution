module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Define states
    typedef enum logic [2:0] {
        S0, S1, S2, S3, S4, S5, S6, S7
    } state_t;

    reg [2:0] current_state, next_state;
    reg disc_next, flag_next, err_next;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next = 1'b0;

        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: begin
                if (in) begin
                    next_state = S6;
                    disc_next = 1'b1;  // Will be discarded next cycle
                end else begin
                    next_state = S0;
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7;
                    err_next = 1'b1;  // Error detected
                end else begin
                    next_state = S0;
                    flag_next = 1'b1;  // Flag detected
                end
            end
            S7: begin
                if (in) begin
                    next_state = S7;
                    err_next = 1'b1;  // Continue error
                end else begin
                    next_state = S0;
                end
            end
            default: next_state = S0;
        endcase
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            current_state <= next_state;
            disc <= disc_next;
            flag <= flag_next;
            err <= err_next;
        end
    end

endmodule