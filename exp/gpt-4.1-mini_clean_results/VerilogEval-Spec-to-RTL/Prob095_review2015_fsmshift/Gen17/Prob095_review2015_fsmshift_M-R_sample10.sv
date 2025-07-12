module TopModule (
    input  wire clk,
    input  wire reset,           // synchronous active-high reset
    input  wire pattern_detected,
    output wire shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state, next_state;
    reg [2:0] counter, next_counter;

    // State and counter registers
    always @(posedge clk) begin
        if (reset) begin
            state   <= ENABLE;
            counter <= 3'd4;
        end else begin
            state   <= next_state;
            counter <= next_counter;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state   = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    next_state   = ENABLE;
                    next_counter = 3'd4;
                end
                // else remain in IDLE, counter unchanged
            end

            ENABLE: begin
                if (counter == 0) begin
                    next_state   = IDLE;
                    next_counter = 0;
                end else begin
                    next_counter = counter - 1;
                end
            end
        endcase
    end

    // shift_ena asserted only in ENABLE state (i.e., during the 4 cycles)
    assign shift_ena = (state == ENABLE);

endmodule