module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Enumerate the states
enum logic [1:0] {
    IDLE,
    PATTERN_DETECT,
    SHIFT,
    COUNTING_DONE
} state, next_state;

// Register to store the input pattern
reg [3:0] pattern;

// Counter for shifting
reg [1:0] shift_count;

// Register to store the shifted data
reg [3:0] shift_data;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        shift_data <= 4'b0000;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    next_state <= PATTERN_DETECT;
                end else begin
                    next_state <= IDLE;
                end
            end
            PATTERN_DETECT: begin
                next_state <= SHIFT;
                shift_count <= 2'b00; // Reset shift count
            end
            SHIFT: begin
                shift_data[3:1] <= shift_data[2:0];
                shift_data[0] <= data;
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin // Shifted 4 times
                    next_state <= COUNTING_DONE;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNTING_DONE: begin
                if (done_counting && ack) begin
                    next_state <= IDLE; // Reset state on ack
                end else if (done_counting) begin
                    next_state <= COUNTING_DONE;
                end else begin
                    next_state <= COUNTING_DONE;
                end
            end
            default: begin
                next_state <= IDLE;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        PATTERN_DETECT: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNTING_DONE: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b1;
        end
        default: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
    endcase
end

endmodule