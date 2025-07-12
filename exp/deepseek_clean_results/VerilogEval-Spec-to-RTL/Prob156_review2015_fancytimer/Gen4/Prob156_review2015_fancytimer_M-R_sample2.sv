module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam S_IDLE       = 3'b000;
    localparam S_PATTERN    = 3'b001;
    localparam S_READ_DELAY = 3'b010;
    localparam S_COUNTING   = 3'b011;
    localparam S_DONE       = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] delay_reg;
    reg [3:0] pattern_reg;
    reg [1:0] bit_counter;
    reg [9:0] cycle_counter; // Counts 0-999 (1000 cycles)
    reg [3:0] count_reg;
    reg counting_reg;
    reg done_reg;

    // Continuous assignments for outputs
    assign count = count_reg;
    assign counting = counting_reg;
    assign done = done_reg;

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset || (state == S_DONE && ack))
            pattern_reg <= 4'b0;
        else if (state == S_IDLE)
            pattern_reg <= {pattern_reg[2:0], data};
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            delay_reg <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 10'b0;
            count_reg <= 4'b0;
            counting_reg <= 1'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                S_IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        bit_counter <= 2'b0;
                        delay_reg <= 4'b0;
                    end
                end

                S_READ_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                end

                S_COUNTING: begin
                    cycle_counter <= cycle_counter + 1;
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        count_reg <= count_reg - 1;
                    end
                end

                S_DONE: begin
                    if (ack) begin
                        done_reg <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        counting_reg = 1'b0;
        done_reg = 1'b0;

        case (state)
            S_IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = S_READ_DELAY;
            end

            S_READ_DELAY: begin
                if (bit_counter == 2'b11) begin
                    next_state = S_COUNTING;
                    counting_reg = 1'b1;
                    count_reg = delay_reg;
                end
            end

            S_COUNTING: begin
                counting_reg = 1'b1;
                if (cycle_counter == 10'd999 && count_reg == 4'b0)
                    next_state = S_DONE;
            end

            S_DONE: begin
                done_reg = 1'b1;
                if (ack)
                    next_state = S_IDLE;
            end
        endcase
    end

endmodule