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
reg [3:0] remaining;
reg [9:0] count_counter;
reg [3:0] count_out;
reg pattern_detected;
reg [3:0] pattern_shift;
reg counting_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pattern_detected <= 1'b0;
        pattern_shift <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        count_counter <= 10'b0000000000;
        remaining <= 4'b0000;
        delay <= 4'b0000;
    end else begin
        if (!pattern_detected) begin
            // Detect pattern 1101
            if (pattern_shift == 4'b1101) begin
                pattern_detected <= 1'b1;
                pattern_shift <= 4'b0000;
            end else begin
                pattern_shift <= {pattern_shift[2:0], data};
            end
        end else if (delay == 4'b0000) begin
            // Capture delay
            if (pattern_shift == 4'b1000) begin
                delay <= {data, pattern_shift[2:0]};
                pattern_shift <= 4'b0000;
            end else begin
                pattern_shift <= {pattern_shift[2:0], data};
            end
        end else if (!counting_reg) begin
            // Start counting
            counting_reg <= 1'b1;
            remaining <= delay;
            count_out <= delay;
        end else if (counting_reg &&!done_reg) begin
            // Count down
            if (count_counter == 10'b1111101000) begin
                count_counter <= 10'b0000000000;
                if (remaining == 4'b0000) begin
                    done_reg <= 1'b1;
                end else begin
                    remaining <= remaining - 1'b1;
                    count_out <= remaining;
                end
            end else begin
                count_counter <= count_counter + 1'b1;
            end
        end else if (done_reg && ack) begin
            // Reset
            pattern_detected <= 1'b0;
            counting_reg <= 1'b0;
            done_reg <= 1'b0;
            count_counter <= 10'b0000000000;
            remaining <= 4'b0000;
            delay <= 4'b0000;
        end
    end
end

assign count = counting_reg? count_out : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule