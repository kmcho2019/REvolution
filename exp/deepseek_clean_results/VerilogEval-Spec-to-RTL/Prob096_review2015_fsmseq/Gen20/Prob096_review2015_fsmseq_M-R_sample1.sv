module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    typedef enum logic [1:0] {
        IDLE,
        GOT1,
        GOT11,
        GOT110
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
            IDLE:    next_state = data ? GOT1 : IDLE;
            GOT1:    next_state = data ? GOT11 : IDLE;
            GOT11:   next_state = data ? GOT11 : GOT110;
            GOT110:  next_state = data ? GOT110 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    assign start_shifting = (current_state == GOT110) && data;

endmodule