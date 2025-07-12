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
reg [9:0] counter;
reg [3:0] remaining;
reg [3:0] shift_reg;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;

integer i;

always @(posedge clk) begin
    if (reset) begin
        // Reset to idle state
        pattern <= 0;
        shift_reg <= 0;
        delay <= 0;
        counter <= 0;
        remaining <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        // Idle state: look for pattern 1101
        if (pattern != 4'b1101) begin
            // Shift in data
            if (data) begin
                pattern <= {pattern[2:0], 1'b1};
            end else begin
                pattern <= {pattern[2:0], 1'b0};
            end
        end else if (shift_reg != 4'b1111) begin
            // Shift in delay
            shift_reg <= shift_reg + 1;
            if (data) begin
                delay <= {delay[2:0], 1'b1};
            end else begin
                delay <= {delay[2:0], 1'b0};
            end
        end else if (!counting_reg) begin
            // Start counting
            counting_reg <= 1;
            remaining <= delay + 1;
            counter <= 0;
        end else if (counting_reg) begin
            // Counting state
            if (counter == 1000) begin
                // Decrement remaining time
                remaining <= remaining - 1;
                counter <= 0;
            end else begin
                // Increment counter
                counter <= counter + 1;
            end
            // Check if counting is done
            if (remaining == 0) begin
                counting_reg <= 0;
                done_reg <= 1;
            end
        end else if (done_reg) begin
            // Done state: wait for ack
            if (ack) begin
                // Reset to idle state
                pattern <= 0;
                shift_reg <= 0;
                delay <= 0;
                counter <= 0;
                remaining <= 0;
                counting_reg <= 0;
                done_reg <= 0;
            end
        end
    end
end

assign count = (counting_reg) ? remaining : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule