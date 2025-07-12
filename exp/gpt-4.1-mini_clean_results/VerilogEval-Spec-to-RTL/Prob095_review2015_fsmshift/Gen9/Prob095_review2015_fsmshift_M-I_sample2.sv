module TopModule (
    input  wire clk,
    input  wire reset,     // synchronous active-high reset
    output wire shift_ena
);

    // State encoding
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state, next_state;
    reg [1:0] counter, next_counter; // 2 bits enough to count from 3 down to 0

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = ENABLE;
                    next_counter = 2'd3; // count down 3,2,1,0 -> 4 cycles
                end
            end
            ENABLE: begin
                if (counter != 0)
                    next_counter = counter - 1'b1;
                else
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential state and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            counter <= 2'd3;
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    // shift_ena is high exactly for 4 cycles: while in ENABLE and counter >= 0,
    // but disable when counter reaches zero (last cycle)
    // Since counter counts down 3 to 0, enable when counter != 0 or when just entered ENABLE
    // Simplify: shift_ena is high whenever state==ENABLE and counter != 0 or counter == 0 (i.e. all cycles)
    // But output one cycle less: enable for cycles with counter=3,2,1,0 -> total 4 cycles exactly.
    // So shift_ena = (state == ENABLE);

    // This works, but to be explicit and safe, assign based on state and counter.
    assign shift_ena = (state == ENABLE);

endmodule