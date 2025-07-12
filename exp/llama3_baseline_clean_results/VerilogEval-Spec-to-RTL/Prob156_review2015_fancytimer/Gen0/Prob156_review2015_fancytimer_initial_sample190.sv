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
reg [13:0] counter;
reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] seq_reg;
reg seq_valid;

always @(posedge clk) begin
    if (reset) begin
        seq_reg <= 0;
        seq_valid <= 0;
        delay <= 0;
        counter <= 0;
        count_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        if (!done_reg) begin
            // Search for the input pattern '1101'
            if (!seq_valid) begin
                seq_reg <= {seq_reg[2:0], data};
                if (seq_reg == 4'b1101) begin
                    seq_valid <= 1;
                end
            end else begin
                // Shift in the next 4 bits to determine the duration of the timer delay
                if (counter < 4) begin
                    delay <= {delay[2:0], data};
                    counter <= counter + 1;
                end else begin
                    // Start counting
                    counting_reg <= 1;
                    counter <= 0;
                    count_reg <= delay;
                end
            end
        end

        // Count for the specified duration and output the remaining time
        if (counting_reg && counter < 1000) begin
            counter <= counter + 1;
        end else if (counting_reg && counter == 1000) begin
            counter <= 0;
            if (count_reg > 0) begin
                count_reg <= count_reg - 1;
            end else begin
                counting_reg <= 0;
                done_reg <= 1;
            end
        end

        // Wait for the ack signal
        if (done_reg && ack) begin
            done_reg <= 0;
            seq_valid <= 0;
            delay <= 0;
            counter <= 0;
            count_reg <= 0;
            counting_reg <= 0;
        end
    end
end

assign count = (counting_reg)? count_reg : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule