module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] count_reg;
reg counting_reg;
reg done_reg;

reg [3:0] delay_reg;
reg [9:0] cycle_count_reg;  // 10 bits to count up to 1000
reg [3:0] counter_reg;
reg [3:0] pattern_reg;  // to store the input pattern
reg [2:0] pattern_shift_reg;  // to keep track of the shift position
reg [3:0] state_reg;  // 2 bits for the state

parameter IDLE = 4'd0;
parameter SHIFT_IN = 4'd1;
parameter COUNTING = 4'd2;
parameter DONE = 4'd3;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'd0;
        counting_reg <= 1'd0;
        done_reg <= 1'd0;
        delay_reg <= 4'd0;
        cycle_count_reg <= 10'd0;
        counter_reg <= 4'd0;
        pattern_reg <= 4'd0;
        pattern_shift_reg <= 3'd0;
        state_reg <= IDLE;
    end else begin
        case (state_reg)
            IDLE: begin
                if (pattern_reg == 4'd13) begin  // 1101
                    state_reg <= SHIFT_IN;
                    pattern_shift_reg <= 3'd0;
                    pattern_reg <= 4'd0;
                end else if (data == 1'b1) begin
                    pattern_reg <= {pattern_reg[2:0], 1'b1};
                end else begin
                    pattern_reg <= {pattern_reg[2:0], 1'b0};
                end
            end

            SHIFT_IN: begin
                delay_reg[{3'd3, pattern_shift_reg}] <= data;
                pattern_shift_reg <= pattern_shift_reg + 1;
                if (pattern_shift_reg == 3'd3) begin
                    state_reg <= COUNTING;
                    counter_reg <= delay_reg;
                    cycle_count_reg <= 10'd0;
                    counting_reg <= 1'd1;
                    count_reg <= counter_reg;
                end
            end

            COUNTING: begin
                if (cycle_count_reg == 10'd999) begin  // count 1000 cycles
                    counter_reg <= counter_reg - 1;
                    cycle_count_reg <= 10'd0;
                    count_reg <= counter_reg;
                end else begin
                    cycle_count_reg <= cycle_count_reg + 1;
                end
                if (counter_reg == 4'd0) begin
                    counting_reg <= 1'd0;
                    state_reg <= DONE;
                end
            end

            DONE: begin
                done_reg <= 1'd1;
                if (ack) begin
                    state_reg <= IDLE;
                    done_reg <= 1'd0;
                end
            end
        endcase
    end
end

assign count = count_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule