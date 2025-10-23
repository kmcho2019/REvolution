module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Initialize q to zero at start for simulation and synthesis
initial begin
    q = 4'b0000;
end

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift data into MSB, shift right
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement q as a 4-bit binary number
        q <= q - 1;
    end
    // else hold q
end

endmodule