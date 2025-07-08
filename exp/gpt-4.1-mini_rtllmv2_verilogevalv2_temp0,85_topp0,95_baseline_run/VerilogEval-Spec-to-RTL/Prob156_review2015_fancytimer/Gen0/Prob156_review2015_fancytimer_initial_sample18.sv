module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    typedef enum reg [1:0] {
        SEARCH = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNTING = 2'b10,
        DONE = 2'b11
    } state_t;
    state_t state, next_state;

    reg [3:0] shift_reg;     // For pattern detection and delay loading
    reg [2:0] delay_bits_cnt; // counts from 0 to 3 during LOAD_DELAY
    reg [3:0] delay;         // loaded delay value
    reg [3:0] current_count; // current countdown value during COUNTING
    reg [9:0] cycle_cnt;     // counts clock cycles from 0 to 999

    // Next state logic and outputs combinational logic
    always @(*) begin
        next_state = state;
        counting = 1'b0;
        done = 1'b0;
        case(state)
            SEARCH: begin
                // Wait for pattern 1101 detection; no outputs asserted
                // next_state depends on whether pattern detected in sequential logic
            end
            LOAD_DELAY: begin
                // After loading 4 bits, move to COUNTING
            end
            COUNTING: begin
                counting = 1'b1;
                if (current_count == 0 && cycle_cnt == 999)
                    next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0000;
            delay_bits_cnt <= 0;
            delay <= 4'b0000;
            current_count <= 4'b0000;
            cycle_cnt <= 10'b0;
            count <= 4'bxxxx; // don't care
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                SEARCH: begin
                    // Shift in data bit into shift_reg
                    shift_reg <= {shift_reg[2:0], data};
                    count <= 4'bxxxx; // don't care in this state
                    counting <= 1'b0;
                    done <= 1'b0;
                    delay_bits_cnt <= 0;
                    cycle_cnt <= 0;
                    current_count <= 0;
                    if (shift_reg == 4'b1101) begin
                        // pattern detected next cycle move to LOAD_DELAY
                        // But state transition controlled by next_state
                    end
                end
                LOAD_DELAY: begin
                    // Shift in 4 bits MSB first into delay
                    // shift_reg used to shift in bits
                    shift_reg <= {shift_reg[2:0], data};
                    delay_bits_cnt <= delay_bits_cnt + 1'b1;

                    if (delay_bits_cnt == 3) begin
                        // After receiving 4 bits, load delay = shift_reg + data bit
                        // shift_reg contains previous 3 bits, data is newest bit
                        // Compose delay bits MSB first:
                        // shift_reg = d0 d1 d2 (oldest on left)
                        // data is newest bit
                        // So delay = {shift_reg[2:0], data}
                        delay <= {shift_reg[2:0], data};
                        current_count <= {shift_reg[2:0], data};
                        cycle_cnt <= 0;
                        count <= {shift_reg[2:0], data};
                    end else begin
                        count <= 4'bxxxx; // don't care
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Count 1000 cycles per count unit
                    if (cycle_cnt == 999) begin
                        cycle_cnt <= 0;
                        if (current_count != 0)
                            current_count <= current_count - 1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1;
                    end

                    // Output count = current_count
                    count <= current_count;
                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care

                    // Wait for ack input before going back to SEARCH
                    // ack handled in next_state logic
                end
            endcase
        end
    end

endmodule