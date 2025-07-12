module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE       = 2'b00;
    localparam SHIFT_DELAY = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_shifter;  // For detecting 1101
    reg [3:0] delay_shifter;    // For capturing delay
    reg [3:0] delay_reg;        // Stored delay value
    reg [2:0] bit_counter;      // Counts 4 bits for delay
    reg [9:0] cycle_counter;    // Counts up to 1000
    reg [3:0] count_down;       // Current count value

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shifter <= 4'b0;
            delay_shifter <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 10'b0;
            count_down <= 4'b0;
            delay_reg <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_shifter <= {pattern_shifter[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                SHIFT_DELAY: begin
                    if (bit_counter < 4) begin
                        delay_shifter <= {delay_shifter[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (count_down == 0) begin
                            next_state <= DONE;
                        end else begin
                            count_down <= count_down - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= count_down;
                end

                DONE: begin
                    done <= 1'b1;
                    if (ack) begin
                        next_state <= IDLE;
                        pattern_shifter <= 4'b0;
                    end
                end
            endcase

            // State transition conditions
            case (state)
                IDLE: 
                    if (pattern_shifter == 4'b1101)
                        next_state <= SHIFT_DELAY;

                SHIFT_DELAY:
                    if (bit_counter == 4) begin
                        next_state <= COUNTING;
                        delay_reg <= delay_shifter;
                        count_down <= delay_shifter;
                        counting <= 1'b1;
                        cycle_counter <= 0;
                    end

                COUNTING:
                    if (count_down == 0 && cycle_counter == 999)
                        next_state <= DONE;

                DONE:
                    if (ack)
                        next_state <= IDLE;
            endcase
        end
    end

endmodule