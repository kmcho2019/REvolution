module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // Gray-coded state encoding
    localparam [2:0]
        IDLE   = 3'b000,
        WAIT   = 3'b001,
        SHIFT  = 3'b011,
        COUNT  = 3'b010,
        DONE   = 3'b110,
        ACK    = 3'b111;

    reg [2:0] state, next_state;
    reg [1:0] shift_cnt;
    reg [3:0] pattern_reg;

    // Pattern detection (parallel comparison)
    wire pattern_match = (pattern_reg == 4'b1101);

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_cnt <= 2'b0;
        end else begin
            state <= next_state;
            pattern_reg <= {pattern_reg[2:0], data};
            
            // Shift counter logic
            if (state == SHIFT) begin
                shift_cnt <= shift_cnt + 1;
            end else begin
                shift_cnt <= 2'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = pattern_match ? WAIT : IDLE;
            WAIT: next_state = SHIFT;  // One-cycle wait for clean transition
            SHIFT: next_state = (shift_cnt == 2'b11) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE: next_state = ACK;
            ACK: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Synchronous output generation
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
        end else begin
            shift_ena <= (next_state == SHIFT);
            counting <= (next_state == COUNT);
            done <= (next_state == DONE) || (next_state == ACK);
        end
    end

endmodule