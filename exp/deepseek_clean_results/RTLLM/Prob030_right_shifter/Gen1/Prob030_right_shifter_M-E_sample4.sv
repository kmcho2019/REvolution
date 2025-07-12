module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    // Right shift operation with explicit bit assignments
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

initial begin
    q = 8'b0;  // Initialization (synthesis-friendly)
end

endmodule