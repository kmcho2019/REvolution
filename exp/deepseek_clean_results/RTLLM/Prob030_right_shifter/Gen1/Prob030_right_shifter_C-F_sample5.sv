module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Initialize shift register to all zeros
initial begin
    q = 8'b0;
end

// On each rising clock edge:
// 1. Shift all bits right by one position
// 2. Insert new input bit at MSB
always @(posedge clk) begin
    q <= {d, q[7:1]};
end

endmodule