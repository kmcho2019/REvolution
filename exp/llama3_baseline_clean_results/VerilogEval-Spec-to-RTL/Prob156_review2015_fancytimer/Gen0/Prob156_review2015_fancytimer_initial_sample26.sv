module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// Define states
typedef enum {IDLE, SHIFT, COUNT, DONE} state_t;

// State register
state_t state, next_state;

// Delay register
reg [3:0] delay;

// Counter register
reg [3:0] counter;
reg [11:0] cycle_counter;

// Shift register
reg [3:0] shift_reg;
reg [1:0] shift_cnt;

// Pattern detector
reg [3:0] pattern_detector;
reg pattern_detected;

always @(*) begin
    case (state)
        IDLE: begin
            if (pattern_detected) begin
                next_state = SHIFT;
            end else if (reset) begin
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_cnt == 4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (cycle_counter == ((delay + 1) * 1000 - 1)) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 0;
        shift_reg <= 0;
        shift_cnt <= 0;
        delay <= 0;
        counter <= 0;
        cycle_counter <= 0;
        pattern_detected <= 0;
    end else begin
        state <= next_state;

        // Pattern detector
        if (state == IDLE) begin
            pattern_detector <= {data, pattern_detector[3:1]};
            if (pattern_detector == 4'b1101) begin
                pattern_detected <= 1;
            end else begin
                pattern_detected <= 0;
            end
        end else begin
            pattern_detector <= 0;
            pattern_detected <= 0;
        end

        // Shift register
        if (state == SHIFT) begin
            shift_reg <= {data, shift_reg[3:1]};
            shift_cnt <= shift_cnt + 1;
            if (shift_cnt == 4) begin
                delay <= shift_reg;
            end
        end else begin
            shift_reg <= 0;
            shift_cnt <= 0;
        end

        // Counter
        if (state == COUNT) begin
            cycle_counter <= cycle_counter + 1;
            if (cycle_counter % 1000 == 0) begin
                counter <= counter - 1;
            end
        end else begin
            counter <= delay;
            cycle_counter <= 0;
        end
    end
end

assign count = (state == COUNT) ? counter : 4'bxxxx;
assign counting = (state == COUNT);
assign done = (state == DONE);

endmodule