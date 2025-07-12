module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

// Initialize q to 0
initial q = 8'b0;

// Capture rising edge of clock
always @(posedge clk) begin
    // Right shift q by 1 bit and insert new input bit d into the most significant position
    q <= {d, q[7:1]};
end

endmodule