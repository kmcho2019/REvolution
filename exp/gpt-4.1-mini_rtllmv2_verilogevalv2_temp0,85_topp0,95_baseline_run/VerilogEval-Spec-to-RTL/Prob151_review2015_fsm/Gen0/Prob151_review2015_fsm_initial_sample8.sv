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

// FSM states
localparam IDLE  = 3'd0;
localparam SHIFT = 3'd1;
localparam COUNT = 3'd2;
localparam DONE  = 3'd3;

reg [2:0] state, next_state;

// Shift register to detect pattern 1101
reg [3:0] pattern_shift;

// Counter for 4 shift cycles
reg [2:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_shift <= 4'b0000;
        shift_count <= 3'd0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;

        case(state)
            IDLE: begin
                // Shift data in to pattern_shift
                pattern_shift <= {pattern_shift[2:0], data};
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
                shift_count <= 3'd0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                shift_count <= shift_count + 3'd1;
                // Continue shifting pattern_shift to keep track in case needed
                pattern_shift <= {pattern_shift[2:0], data};
            end
            COUNT: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
            end
            DONE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
            default: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case(state)
        IDLE: begin
            // Wait until pattern_shift equals 1101 (4'b1101)
            if (pattern_shift == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            // Stay in SHIFT for exactly 4 cycles
            if (shift_count == 3'd4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            // Wait until done_counting asserted
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            // Wait for ack to go high
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule