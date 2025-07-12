module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    typedef enum logic [0:0] {
        IDLE   = 1'b0,
        ENABLE = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] counter, next_counter;

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = ENABLE;
                    next_counter = 3'd4;
                end
            end
            ENABLE: begin
                if (counter != 0)
                    next_counter = counter - 1;
                else
                    next_state = IDLE;
            end
        endcase
    end

    // State and counter registers
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            counter <= 3'd4;
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    // Output logic: shift_ena is high in ENABLE state
    assign shift_ena = (state == ENABLE);

endmodule