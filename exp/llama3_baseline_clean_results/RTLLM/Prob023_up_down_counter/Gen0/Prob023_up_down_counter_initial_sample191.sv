module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 16'd0; // Reset the counter to zero
    end else begin
        if (up_down) begin
            count_reg <= count_reg + 16'd1; // Increment the counter
        end else begin
            count_reg <= count_reg - 16'd1; // Decrement the counter
        end
    end
end

assign count = count_reg; // Assign the internal register to the output

endmodule