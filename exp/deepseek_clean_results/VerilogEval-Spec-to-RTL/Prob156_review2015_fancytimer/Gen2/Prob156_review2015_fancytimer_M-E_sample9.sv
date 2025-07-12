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
    typedef enum logic [1:0] {
        IDLE,
        CAPTURE,
        RUN,
        COMPLETE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection
    reg [3:0] pattern_shift;
    wire pattern_match = (pattern_shift == 4'b1101);

    // Delay capture
    reg [3:0] delay_shift;
    reg [2:0] bit_counter;
    reg [3:0] delay_value;

    // Timing counters
    reg [9:0] cycles_counter;  // Counts 0-999 (10 bits)
    reg [3:0] delay_counter;   // Current delay countdown

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_shift <= 4'b0;
            delay_shift <= 4'b0;
            bit_counter <= 3'b0;
            delay_value <= 4'b0;
            cycles_counter <= 10'b0;
            delay_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                CAPTURE: begin
                    if (bit_counter < 4) begin
                        delay_shift <= {delay_shift[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                RUN: begin
                    if (cycles_counter == 999) begin
                        cycles_counter <= 10'b0;
                        if (delay_counter != 0)
                            delay_counter <= delay_counter - 1;
                    end else begin
                        cycles_counter <= cycles_counter + 1;
                    end
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_counter;
                end

                COMPLETE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: 
                next_state = pattern_match ? CAPTURE : IDLE;

            CAPTURE: 
                next_state = (bit_counter == 4) ? RUN : CAPTURE;

            RUN: 
                next_state = (delay_counter == 0 && cycles_counter == 999) ? 
                            COMPLETE : RUN;

            COMPLETE: 
                next_state = ack ? IDLE : COMPLETE;

            default: 
                next_state = IDLE;
        endcase
    end

    // Delay value capture
    always @(posedge clk) begin
        if (current_state == CAPTURE && bit_counter == 4) begin
            delay_value <= delay_shift;
            delay_counter <= delay_shift;
        end
    end

endmodule