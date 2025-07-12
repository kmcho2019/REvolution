module right_shifter (
    input wire clk,       // Clock input
    input wire d,         // Data input
    output reg [7:0] q    // Shift register output
);

// Initialize register to zero
initial begin
    q = 8'b00000000;
end

// Right shift operation on each clock edge
always @(posedge clk) begin
    q <= {d, q[7:1]};    // Concatenate input with upper 7 bits of q
end

endmodule