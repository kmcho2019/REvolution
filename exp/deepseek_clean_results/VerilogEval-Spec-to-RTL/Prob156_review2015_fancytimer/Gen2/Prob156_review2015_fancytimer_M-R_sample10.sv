module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam COUNT = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;  // Shift register for 1101 pattern
    reg [3:0] delay_reg;    // Shift register for delay bits
    reg [2:0] bit_cnt;      // Counts bits loaded (0-7)
    reg [15:0] cycle_cnt;   // Main cycle counter
    reg [15:0] target_cycles; // Computed target cycles

    // Continuous output assignment
    assign count = (state == COUNT) ? target_cycles[15:12] : 4'b0;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (pattern_reg == 4'b1101) ? LOAD : IDLE;
            LOAD: next_state = (bit_cnt == 7) ? COUNT : LOAD;
            COUNT: next_state = (cycle_cnt >= target_cycles) ? IDLE : COUNT;
            default: next_state = IDLE;
        endcase
    end

    // State machine and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_cnt <= 3'b0;
            cycle_cnt <= 16'b0;
            target_cycles <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in data to pattern register
            pattern_reg <= {pattern_reg[2:0], data};

            case (state)
                IDLE: begin
                    cycle_cnt <= 16'b0;
                    bit_cnt <= 3'b0;
                    counting <= 1'b0;
                    done <= 1'b0;

                    if (pattern_reg == 4'b1101) begin
                        bit_cnt <= 3'b1; // Start counting delay bits
                    end
                end

                LOAD: begin
                    if (bit_cnt < 7) begin
                        bit_cnt <= bit_cnt + 1;
                        // Shift in delay bits (bits 4-7)
                        if (bit_cnt >= 3) begin
                            delay_reg <= {delay_reg[2:0], data};
                        end
                    end else begin
                        // Calculate (delay + 1) * 1000
                        target_cycles <= (delay_reg + 1) << 10;
                        counting <= 1'b1;
                    end
                end

                COUNT: begin
                    if (cycle_cnt < target_cycles) begin
                        cycle_cnt <= cycle_cnt + 1;
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                    end

                    if (done && ack) begin
                        done <= 1'b0;
                        pattern_reg <= 4'b0; // Reset pattern detection
                    end
                end
            endcase
        end
    end

endmodule