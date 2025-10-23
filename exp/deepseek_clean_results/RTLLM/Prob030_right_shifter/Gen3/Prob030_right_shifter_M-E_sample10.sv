module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Initialize shift register to all zeros
initial begin
    q = 8'b0;
end

// Explicit bit assignment implementation
always @(posedge clk) begin
    // Shift each bit right by one position
    q[6] <= q[7];
    q[5] <= q[6];
    q[4] <= q[5];
    q[3] <= q[4];
    q[2] <= q[3];
    q[1] <= q[2];
    q[0] <= q[1];
    
    // Insert new bit at MSB
    q[7] <= d;
end

endmodule