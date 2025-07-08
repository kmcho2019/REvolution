module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in data MSB first
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the 4-bit register
        q <= q - 1;
    end
    // else hold value
end

endmodule