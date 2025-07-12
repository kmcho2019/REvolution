module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

// Initialize q to zero to avoid unknown states in simulation
initial begin
    q = 4'b0000;
end

always @(posedge clk) begin
    if (count_ena) begin
        // Decrement the 4-bit value, wrapping around naturally
        q <= q - 1;
    end else if (shift_ena) begin
        // Shift right by one, insert data at MSB (bit 3)
        q <= {data, q[3:1]};
    end
    // else hold q
end

endmodule