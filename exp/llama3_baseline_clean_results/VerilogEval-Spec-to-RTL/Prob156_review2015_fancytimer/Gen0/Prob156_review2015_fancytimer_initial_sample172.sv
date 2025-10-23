module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

typedef enum logic [2:0] {IDLE, SHIFT, COUNTING, DONE} state_t;
state_t state, next_state;

reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] cycle_count;
reg [3:0] shift_reg;

always @(*) begin
    case (state)
        IDLE: begin
            if (shift_reg == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_reg == 4'b1101) begin
                delay = {data, shift_reg[2:0]};
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (cycle_count == (delay + 1) * 1000 - 1) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'b0;
        counting <= 0;
        done <= 0;
        cycle_count <= 0;
        shift_reg <= 0;
        remaining <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                shift_reg <= {data, shift_reg[3:1]};
                count <= 4'b0;
                counting <= 0;
                done <= 0;
                cycle_count <= 0;
            end
            SHIFT: begin
                shift_reg <= {data, shift_reg[3:1]};
            end
            COUNTING: begin
                if (cycle_count == (remaining + 1) * 1000 - 1) begin
                    remaining <= remaining - 1;
                end
                cycle_count <= cycle_count + 1;
                count <= remaining;
                counting <= 1;
            end
            DONE: begin
                done <= 1;
                counting <= 0;
            end
        endcase
    end
end

endmodule