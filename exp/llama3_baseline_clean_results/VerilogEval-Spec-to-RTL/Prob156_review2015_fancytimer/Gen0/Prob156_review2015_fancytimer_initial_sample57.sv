module TopModule (
    input         clk,
    input         reset,
    input         data,
    output [3:0]  count,
    output        counting,
    output        done,
    input         ack
);

reg [3:0]    delay;
reg [11:0]   remaining_count;
reg [3:0]    output_count;
reg [3:0]    shift_reg;
reg          counting_reg;
reg          done_reg;

enum logic [2:0] {IDLE, SHIFT_DELAY, COUNTING, DONE} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counting_reg <= 0;
        done_reg <= 0;
        remaining_count <= 0;
        output_count <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state <= SHIFT_DELAY;
                    delay <= 0;
                end else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFT_DELAY: begin
                delay <= {data, delay[2:0]};
                if (delay[0]) begin
                    next_state <= COUNTING;
                    remaining_count <= (delay + 1) * 1000;
                    counting_reg <= 1;
                end else begin
                    next_state <= SHIFT_DELAY;
                end
            end
            COUNTING: begin
                if (remaining_count == 1) begin
                    next_state <= DONE;
                    done_reg <= 1;
                    counting_reg <= 0;
                end else begin
                    remaining_count <= remaining_count - 1;
                    if (remaining_count[0]) begin
                        output_count <= delay;
                    end else begin
                        if (output_count > 0) begin
                            output_count <= output_count - 1;
                        end
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                    done_reg <= 0;
                end else begin
                    next_state <= DONE;
                end
            end
        endcase
    end
end

assign count = output_count;
assign counting = counting_reg;
assign done = done_reg;

endmodule