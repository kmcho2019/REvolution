module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Sequential logic to update q on rising edge of clk
always @(posedge clk) begin
    if (shift_ena) begin
        // Shift left by one towards LSB, insert data at MSB
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Treat q as a binary number and decrement by 1
        q <= q - 4'd1;
    end
    // If neither enabled, retain q implicitly
end

endmodule