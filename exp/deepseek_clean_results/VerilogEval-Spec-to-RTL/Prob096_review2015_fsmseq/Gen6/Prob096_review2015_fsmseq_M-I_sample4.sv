module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    typedef enum logic [1:0] {
        S_IDLE = 2'b00,
        S_1    = 2'b01,
        S_11   = 2'b10,
        S_110  = 2'b11
    } state_t;

    state_t current_state, next_state;
    reg clk_enable;

    // State transition logic
    always_comb begin
        next_state = current_state;
        clk_enable = 1'b1;
        
        if (start_shifting) begin
            clk_enable = 1'b0;  // Freeze state after detection
        end
        else case (current_state)
            S_IDLE: next_state = data ? S_1 : S_IDLE;
            S_1:    next_state = data ? S_11 : S_IDLE;
            S_11:   next_state = data ? S_11 : S_110;
            S_110: next_state = data ? S_IDLE : S_IDLE;
        endcase
    end

    // State register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
        end else if (clk_enable) begin
            current_state <= next_state;
        end
    end

    // Output logic (combinational)
    assign start_shifting = (current_state == S_110) && data;

endmodule