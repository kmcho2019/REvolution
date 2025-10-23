module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // Main states
    typedef enum logic [1:0] {
        IDLE,
        CAPTURE,
        COUNT,
        DONE
    } state_t;

    // Sub-counting states
    typedef enum logic {
        SUB_IDLE,
        SUB_COUNT
    } substate_t;

    state_t state;
    substate_t substate;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [2:0] bit_cnt;
    reg [9:0] sub_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] main_counter; // Tracks remaining delay steps

    // Continuous pattern matching
    wire pattern_match = (shift_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            substate <= SUB_IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            bit_cnt <= 3'b0;
            sub_counter <= 10'b0;
            main_counter <= 4'b0;
            count <= 4'b0;
        end else begin
            // Shift register operates in all states except COUNT/DONE
            if (state != COUNT && state != DONE) begin
                shift_reg <= {shift_reg[2:0], data};
            end

            case (state)
                IDLE: begin
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bit_cnt <= 3'b0;
                    end
                end

                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    if (bit_cnt == 3'b11) begin
                        state <= COUNT;
                        main_counter <= delay;
                        sub_counter <= 10'b0;
                        substate <= SUB_COUNT;
                        count <= delay;
                    end
                    bit_cnt <= bit_cnt + 1;
                end

                COUNT: begin
                    case (substate)
                        SUB_COUNT: begin
                            if (sub_counter == 10'd999) begin
                                sub_counter <= 10'b0;
                                main_counter <= main_counter - 1;
                                count <= main_counter - 1;
                                
                                if (main_counter == 4'b0) begin
                                    state <= DONE;
                                end
                            end else begin
                                sub_counter <= sub_counter + 1;
                            end
                        end
                    endcase
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule