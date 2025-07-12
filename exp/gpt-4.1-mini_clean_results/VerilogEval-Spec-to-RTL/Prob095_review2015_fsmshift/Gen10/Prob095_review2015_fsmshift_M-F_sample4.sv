module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,
    output wire shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state, next_state;
    reg [1:0] counter, next_counter;  // 2 bits sufficient for counting 4 cycles (0 to 3)

    // Next state and counter combinational logic
    always @(*) begin
        next_state = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                // On synchronous reset or pattern_detected, start enabling
                if (reset || pattern_detected) begin
                    next_state = ENABLE;
                    next_counter = 2'd3; // count down 3,2,1,0 = 4 cycles total
                end
            end

            ENABLE: begin
                if (counter == 0)
                    next_state = IDLE;
                else
                    next_counter = counter - 1;
            end
        endcase
    end

    // Sequential state and counter update on posedge clk, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            counter <= 2'd3;
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    // shift_ena is high during ENABLE state, exactly 4 cycles after reset or pattern_detected
    assign shift_ena = (state == ENABLE);

endmodule