module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States represent how many bits of the pattern have been matched
    typedef enum logic [1:0] {
        IDLE,       // 0 bits matched
        GOT1,       // 1 (first bit matched)
        GOT11,      // 11 (first two bits matched)
        GOT110      // 110 (first three bits matched)
    } state_t;

    state_t current_state, next_state;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            found <= 1'b0;
        end else if (!found) begin
            current_state <= next_state;
            // Check if we've completed the pattern in this cycle
            if (current_state == GOT110 && data == 1'b1)
                found <= 1'b1;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            IDLE:   next_state = (data == 1'b1) ? GOT1 : IDLE;
            GOT1:   next_state = (data == 1'b1) ? GOT11 : IDLE;
            GOT11:  next_state = (data == 1'b0) ? GOT110 : GOT11;
            GOT110: next_state = (data == 1'b1) ? IDLE : GOT110;
            default: next_state = IDLE;
        endcase
    end

    assign start_shifting = found;

endmodule