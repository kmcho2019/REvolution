module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in data from MSB when shift_ena is 1
        q = {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the number in the shift register when count_ena is 1
        if (q == 4'b0000) begin
            q = 4'b1111;  // Underflow handling: wrap around to 15
        end else begin
            q = q - 1;
        end
    end
end

endmodule