module TopModule(
    input         clk,
    input         reset,
    input         data,
    output [3:0]  count,
    output        counting,
    output        done,
    input         ack
);

reg [3:0]       delay;
reg [3:0]       remaining;
reg [9:0]       counter;
reg [3:0]       count_out;
reg [3:0]       shift_reg;

enum {IDLE, SHIFT, COUNTING, DONE} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count_out <= 4'b0;
        remaining <= 4'b0;
        counter <= 10'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            SHIFT: begin
                if (counter == 10'b1000) begin
                    state <= COUNTING;
                end else begin
                    delay <= {delay[2:0], data};
                    counter <= counter + 1;
                end
            end
            COUNTING: begin
                if (counter == (delay + 1) * 10'b1000) begin
                    state <= DONE;
                end else begin
                    if (counter % 10'b1000 == 10'b0) begin
                        remaining <= remaining - 1;
                    end
                    counter <= counter + 1;
                    count_out <= remaining;
                    counting <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    counting <= 1'b0;
                    done <= 1'b0;
                    shift_reg <= 4'b0;
                    counter <= 10'b0;
                    remaining <= delay;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = IDLE;
        SHIFT: next_state = SHIFT;
        COUNTING: next_state = COUNTING;
        DONE: next_state = DONE;
    endcase
end

assign count = count_out;
assign done = (state == DONE) ? 1'b1 : 1'b0;

initial begin
    state = IDLE;
    count_out = 4'b0;
    remaining = 4'b0;
    counter = 10'b0;
    counting = 1'b0;
    done = 1'b0;
    shift_reg = 4'b0;
end

endmodule