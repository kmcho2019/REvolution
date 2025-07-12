module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg; // internal register to store the counter value

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when reset signal is active
        count_reg <= 16'd0;
    end else begin
        if (up_down) begin
            // Increment the counter when up_down signal is high
            count_reg <= count_reg + 1;
        end else begin
            // Decrement the counter when up_down signal is low
            count_reg <= count_reg - 1;
        end
    end
end

assign count = count_reg; // assign the internal counter value to the output

endmodule