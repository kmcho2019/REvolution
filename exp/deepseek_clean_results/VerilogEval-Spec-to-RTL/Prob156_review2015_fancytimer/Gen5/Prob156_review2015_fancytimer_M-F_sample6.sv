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
    parameter IDLE = 2'b00;
    parameter CAPTURE = 2'b01;
    parameter RUN = 2'b10;
    parameter COMPLETE = 2'b11;

    reg [1:0] state, next_state;

    // Pattern detection
    reg [3:0] pattern_reg;
    wire pattern_match = (pattern_reg == 4'b1101);

    // Delay capture
    reg [3:0] delay_reg;
    reg [1:0] bit_count;
    reg [3:0] delay_value;

    // Timing counters
    reg [9:0] cycle_count;  // Counts 0-999 (1000 cycles)
    reg [3:0] delay_count;  // Current delay countdown

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            next_state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Main logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 2'b0;
            delay_value <= 4'b0;
            cycle_count <= 10'b0;
            delay_count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in pattern bits
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    
                    // Clear capture registers when leaving IDLE
                    if (pattern_match) begin
                        delay_reg <= 4'b0;
                        bit_count <= 2'b0;
                    end
                end

                CAPTURE: begin
                    // Shift in delay bits
                    if (bit_count < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end
                end

                RUN: begin
                    // Count cycles
                    if (cycle_count == 999) begin
                        cycle_count <= 10'b0;
                        if (delay_count == 0) begin
                            // Counting complete
                        end else begin
                            delay_count <= delay_count - 1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                    
                    // Update count output
                    count <= delay_count;
                end

                COMPLETE: begin
                    // Wait for ack
                    if (ack) begin
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = pattern_match ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_count == 4) ? RUN : CAPTURE;
            RUN: next_state = (delay_count == 0 && cycle_count == 999) ? COMPLETE : RUN;
            COMPLETE: next_state = ack ? IDLE : COMPLETE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            counting <= (state == RUN);
            done <= (state == COMPLETE);
            
            // Initialize counters when entering RUN state
            if (state == CAPTURE && next_state == RUN) begin
                delay_value <= delay_reg;
                delay_count <= delay_reg;
                cycle_count <= 10'b0;
            end
        end
    end

endmodule