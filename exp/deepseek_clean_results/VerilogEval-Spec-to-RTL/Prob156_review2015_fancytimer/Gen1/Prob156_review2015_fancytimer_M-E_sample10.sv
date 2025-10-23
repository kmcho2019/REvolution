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
    localparam IDLE     = 1'b0;
    localparam ACTIVE   = 1'b1;

    reg state, next_state;
    reg [3:0] history;      // Last 4 data bits
    reg [3:0] delay;        // Stored delay value
    reg [2:0] bit_counter;  // Counts bits received (0-7)
    reg [3:0] block_counter; // Counts remaining 1000-cycle blocks
    reg [9:0] cycle_counter; // Counts cycles within block (0-999)

    // Pattern detection (combinatorial)
    wire pattern_match = (history == 4'b1101);

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = pattern_match ? ACTIVE : IDLE;
            ACTIVE: next_state = (done && ack) ? IDLE : ACTIVE;
        endcase
    end

    // State machine and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            history <= 4'b0;
            delay <= 4'b0;
            bit_counter <= 3'b0;
            block_counter <= 4'b0;
            cycle_counter <= 10'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            history <= {history[2:0], data};

            case (state)
                IDLE: begin
                    bit_counter <= 3'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    
                    if (pattern_match) begin
                        bit_counter <= 3'b1; // Start counting delay bits
                    end
                end

                ACTIVE: begin
                    // Shift in delay bits (bits 4-7 after pattern)
                    if (bit_counter < 7) begin
                        bit_counter <= bit_counter + 1;
                        if (bit_counter >= 3) begin
                            delay <= {delay[2:0], data};
                        end
                    end
                    // Start counting after all bits received
                    else if (bit_counter == 7) begin
                        bit_counter <= bit_counter + 1;
                        block_counter <= delay;
                        counting <= 1'b1;
                    end
                    // Counting logic
                    else if (counting) begin
                        if (cycle_counter == 999) begin
                            cycle_counter <= 0;
                            if (block_counter == 0) begin
                                counting <= 1'b0;
                                done <= 1'b1;
                            end else begin
                                block_counter <= block_counter - 1;
                            end
                        end else begin
                            cycle_counter <= cycle_counter + 1;
                        end
                    end
                    // Done state
                    else if (done && ack) begin
                        done <= 1'b0;
                        history <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Output generation
    always @(*) begin
        if (counting) begin
            count = block_counter;
        end else begin
            count = 4'b0; // Don't care when not counting
        end
    end

endmodule