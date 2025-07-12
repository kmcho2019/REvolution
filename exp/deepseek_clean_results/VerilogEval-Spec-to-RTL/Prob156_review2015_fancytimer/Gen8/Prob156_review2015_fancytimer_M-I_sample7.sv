module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam IDLE          = 2'b00;
    localparam CAPTURE_DELAY = 2'b01;
    localparam COUNTING      = 2'b10;
    localparam DONE          = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [3:0] final_delay;
    reg [1:0] bit_counter;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] remaining_chunks;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            bit_counter <= 0;
            cycle_counter <= 0;
            remaining_chunks <= 0;
            final_delay <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                    count <= 4'b0;
                end

                CAPTURE_DELAY: begin
                    if (bit_counter < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        remaining_chunks <= remaining_chunks - 1;
                        count <= remaining_chunks - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    // Hold done until ack
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (pattern_reg == 4'b1101) ? CAPTURE_DELAY : IDLE;
            end

            CAPTURE_DELAY: begin
                next_state = (bit_counter == 4) ? COUNTING : CAPTURE_DELAY;
            end

            COUNTING: begin
                if (cycle_counter == 999 && remaining_chunks == 0)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                next_state = ack ? IDLE : DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output and counter initialization logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (next_state)
                CAPTURE_DELAY: begin
                    if (state == IDLE) begin
                        bit_counter <= 0;
                        delay_val <= 4'b0;
                    end
                end

                COUNTING: begin
                    if (state == CAPTURE_DELAY) begin
                        final_delay <= delay_val;
                        remaining_chunks <= delay_val;
                        cycle_counter <= 0;
                        count <= delay_val;
                        counting <= 1;
                    end
                end

                DONE: begin
                    if (state == COUNTING) begin
                        done <= 1;
                        counting <= 0;
                    end
                end
            endcase
        end
    end

endmodule