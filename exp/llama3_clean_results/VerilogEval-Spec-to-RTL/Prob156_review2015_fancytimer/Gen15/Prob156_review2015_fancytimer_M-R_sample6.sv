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
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Registers
reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [3:0] pattern_reg;
reg [1:0] shift_count;

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (pattern_reg == 4'b1101) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if (shift_count == 4) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (counter == 0) begin
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack == 1'b1) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 0;
        counter <= 0;
        remaining_time <= 0;
        pattern_reg <= 0;
        shift_count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                pattern_reg <= {pattern_reg[2:0], data};
            end
            SHIFT: begin
                delay_reg <= {data, delay_reg[3:1]};
                shift_count <= shift_count + 1;
            end
            COUNT: begin
                counting <= 1'b1;
                counter <= counter - 1;
                if (counter[0] == 1'b0) begin
                    remaining_time <= remaining_time - 1;
                end
            end
            DONE: begin
                counting <= 0;
                done <= 1'b1;
            end
        endcase
        if (state == IDLE && pattern_reg == 4'b1101) begin
            delay_reg <= 0;
            shift_count <= 1;
        end
        if (state == SHIFT && shift_count == 4) begin
            counter <= (delay_reg + 1) * 1000 - 1;
            remaining_time <= delay_reg;
        end
    end
end

// Output logic
assign count = remaining_time;