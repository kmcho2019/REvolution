module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift left by one, insert data at LSB (bit 0)
        q <= {q[2:0], data};
    end else if (count_ena) begin
        // Decrement the 4-bit value
        q <= q - 1;
    end
    // else hold q
end

endmodule