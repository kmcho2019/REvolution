module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [9:0] clock_counter;
reg counting_reg;
reg done_reg;
reg [3:0] shift_reg;

enum {IDLE, SHIFT, COUNT, DONE} state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counting_reg <= 0;
        done_reg <= 0;
        shift_reg <= 0;
        counter <= 0;
        clock_counter <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'd13) begin // 1101 in binary is 13
                    state <= SHIFT;
                    shift_reg <= 0;
                end else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFT: begin
                delay <= {delay[2:0], data};
                shift_reg <= shift_reg + 1;
                if (shift_reg == 4) begin
                    state <= COUNT;
                    counter <= delay + 1;
                    clock_counter <= 0;
                    counting_reg <= 1;
                end
            end
            COUNT: begin
                if (clock_counter == 1000 - 1) begin
                    clock_counter <= 0;
                    counter <= counter - 1;
                    count <= counter;
                end else begin
                    clock_counter <= clock_counter + 1;
                    count <= counter;
                end
                if (counter == 0) begin
                    state <= DONE;
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;

endmodule