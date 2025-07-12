module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Initialize shift register to all zeros
initial begin
    q = 8'b0;
end

// Simplified shift operation
always @(posedge clk) begin
    q <= {d, q[7:1]};  // Concatenate input with upper 7 bits
end

endmodule