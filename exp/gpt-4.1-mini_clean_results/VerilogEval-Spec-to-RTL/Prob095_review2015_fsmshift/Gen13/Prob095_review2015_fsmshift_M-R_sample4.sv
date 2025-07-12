module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam SHIFT_ENABLE = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_counter;  // Counts 4 cycles (0 to 3)

    // State and counter update on clock edge
    always @(posedge clk) begin
        if (reset) begin
            state <= SHIFT_ENABLE;
            cycle_counter <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT_ENABLE) begin
                cycle_counter <= cycle_counter + 1'b1;
            end else begin
                cycle_counter <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SHIFT_ENABLE: begin
                // After 4 cycles (count 0..3), go to IDLE
                if (cycle_counter == 2'd3)
                    next_state = IDLE;
                else
                    next_state = SHIFT_ENABLE;
            end
            IDLE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    assign shift_ena = (state == SHIFT_ENABLE);

endmodule