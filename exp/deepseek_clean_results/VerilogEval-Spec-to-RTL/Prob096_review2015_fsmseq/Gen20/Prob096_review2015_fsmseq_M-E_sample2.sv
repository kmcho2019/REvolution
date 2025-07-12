module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // States for sequence detection
    typedef enum logic [2:0] {
        IDLE,
        GOT1,
        GOT11,
        GOT110,
        FOUND
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? GOT11 : GOT110;
            GOT110: next_state = data ? FOUND : IDLE;
            FOUND:  next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

    assign start_shifting = (current_state == FOUND);

endmodule