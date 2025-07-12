module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    typedef enum logic [2:0] {
        INIT,   // Initial/reset state (previous input was 0)
        S1,     // 1 consecutive 1
        S2,     // 2 consecutive 1s
        S3,     // 3 consecutive 1s
        S4,     // 4 consecutive 1s
        S5,     // 5 consecutive 1s
        S6,     // 6 consecutive 1s
        DISC,   // Discard state (output disc)
        FLAG,   // Flag state (output flag)
        ERR     // Error state (output err)
    } state_t;

    state_t current_state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= INIT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            INIT: next_state = in ? S1 : INIT;
            S1:   next_state = in ? S2 : INIT;
            S2:   next_state = in ? S3 : INIT;
            S3:   next_state = in ? S4 : INIT;
            S4:   next_state = in ? S5 : INIT;
            S5:   next_state = in ? S6 : (in ? S6 : DISC);
            S6:   next_state = in ? ERR : FLAG;
            DISC: next_state = in ? S1 : INIT;
            FLAG: next_state = in ? S1 : INIT;
            ERR:  next_state = in ? ERR : INIT;
            default: next_state = INIT;
        endcase
    end

    // Output logic (Moore style - outputs depend only on current state)
    always @(posedge clk) begin
        if (reset) begin
            {disc_reg, flag_reg, err_reg} <= 3'b0;
        end else begin
            disc_reg <= (current_state == DISC);
            flag_reg <= (current_state == FLAG);
            err_reg <= (current_state == ERR);
        end
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule