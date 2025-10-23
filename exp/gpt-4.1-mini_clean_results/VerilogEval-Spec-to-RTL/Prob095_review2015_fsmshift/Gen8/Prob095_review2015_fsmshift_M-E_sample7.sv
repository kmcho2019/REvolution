module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    typedef enum logic [0:0] {
        IDLE   = 1'b0,
        ENABLE = 1'b1
    } state_t;

    state_t state, next_state;
    reg [1:0] counter, next_counter;

    // State and counter registers
    always @(posedge clk) begin
        if (reset) begin
            state   <= ENABLE;
            counter <= 2'd4; // Load count for 4 cycles
        end else begin
            state   <= next_state;
            counter <= next_counter;
        end
    end

    // Next-state and counter logic
    always @(*) begin
        next_state = state;
        next_counter = counter;
        case (state)
            ENABLE: begin
                if (counter == 0) begin
                    next_state = IDLE;
                end else begin
                    next_counter = counter - 1;
                end
            end
            IDLE: begin
                // Stay in IDLE until reset occurs (handled synchronously)
            end
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == ENABLE);
    end

endmodule