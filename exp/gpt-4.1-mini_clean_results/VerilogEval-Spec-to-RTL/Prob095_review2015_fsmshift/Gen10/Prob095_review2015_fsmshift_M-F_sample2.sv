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
                    next_counter = 3'd3;  // Count down from 3 to 0 = 4 cycles total
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
            counter <= 3'd3;  // Initialize to 3 for exactly 4 enable cycles
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    // Output logic: shift_ena asserted whenever in ENABLE state (4 cycles: counter=3,2,1,0)
    assign shift_ena = (state == ENABLE);

endmodule