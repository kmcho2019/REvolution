module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] shift_reg;  // Shift register for reading 1101 pattern and delay
reg [3:0] delay;      // Delay value
reg [3:0] counter;    // Counter for counting
reg counting_reg;     // Counting signal
reg done_reg;         // Done signal
reg [9:0] clock_counter;  // Counter for 1000 clock cycles

enum logic [2:0] {
    IDLE,
    READ_DELAY,
    COUNTING,
    DONE
} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counting_reg <= 0;
        done_reg <= 0;
        clock_counter <= 0;
        counter <= 0;
        shift_reg <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101) begin
                    next_state <= READ_DELAY;
                end else begin
                    next_state <= IDLE;
                end
            end
            READ_DELAY: begin
                if (shift_reg == 4'b1101_0000) begin
                    delay <= shift_reg[3:0];
                    next_state <= COUNTING;
                end else begin
                    next_state <= READ_DELAY;
                end
            end
            COUNTING: begin
                if (counter == 0 && clock_counter == 0) begin
                    next_state <= DONE;
                end else begin
                    next_state <= COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE;
                end
            end
        endcase
        case (state)
            IDLE: begin
                if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
                counting_reg <= 0;
                done_reg <= 0;
            end
            READ_DELAY: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[3] == 1'b1) begin
                    counting_reg <= 1;
                    counter <= delay + 1;
                end
            end
            COUNTING: begin
                if (clock_counter == 1000) begin
                    clock_counter <= 0;
                    counter <= counter - 1;
                    if (counter > 0) begin
                        counting_reg <= 1;
                    end
                end else begin
                    clock_counter <= clock_counter + 1;
                end
            end
            DONE: begin
                done_reg <= 1;
                counting_reg <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == COUNTING) begin
        count <= counter - 1;
    end else begin
        count <= 0;
    end
end

assign counting = counting_reg;
assign done = done_reg;

endmodule