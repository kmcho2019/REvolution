module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift the counter one bit to the right and fill the MSB with the new data bit
        counter <= {data, counter[3:1]};
    end else if (count_ena) begin
        // Decrement the counter if it is not already zero
        counter <= (counter == 4'b0) ? 4'b0 : (counter - 1);
    end else begin
        // Maintain current state when neither shift_ena nor count_ena is high
        counter <= counter;
    end
end

assign q = counter;

endmodule