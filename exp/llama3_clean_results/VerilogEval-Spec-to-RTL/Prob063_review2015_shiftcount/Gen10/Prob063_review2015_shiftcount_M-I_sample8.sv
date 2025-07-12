module TopModule (
    input clk,
    input rst_n, // Active low reset
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 4'b0000; // Reset counter to 0 on active low reset
    end else if (shift_ena) begin
        // Shift in new data from the most significant bit
        counter <= {data, counter[3:1]};
    end else if (count_ena) begin
        // Decrement counter if it's greater than 0
        if (counter > 0) begin
            counter <= counter - 1;
        end
    end
end

assign q = counter;

endmodule