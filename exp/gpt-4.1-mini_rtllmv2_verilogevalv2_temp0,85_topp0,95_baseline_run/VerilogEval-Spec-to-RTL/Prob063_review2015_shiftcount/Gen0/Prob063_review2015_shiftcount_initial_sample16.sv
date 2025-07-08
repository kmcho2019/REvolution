module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift left, input data into MSB
        q <= {q[2:0], data};
    end else if (count_ena) begin
        // Decrement the 4-bit value
        q <= q - 4'b0001;
    end
    // else retain the current value
end

endmodule