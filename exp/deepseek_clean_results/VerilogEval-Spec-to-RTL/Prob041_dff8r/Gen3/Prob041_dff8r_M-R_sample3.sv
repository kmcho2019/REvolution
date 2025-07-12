module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Implement 8 DFFs using continuous assignments with clock edge detection
// Each bit has its own assignment with synchronous reset logic
reg [7:0] q_reg;

assign q = q_reg;

always @(posedge clk) begin
    q_reg[0] <= reset ? 1'b0 : d[0];
    q_reg[1] <= reset ? 1'b0 : d[1];
    q_reg[2] <= reset ? 1'b0 : d[2];
    q_reg[3] <= reset ? 1'b0 : d[3];
    q_reg[4] <= reset ? 1'b0 : d[4];
    q_reg[5] <= reset ? 1'b0 : d[5];
    q_reg[6] <= reset ? 1'b0 : d[6];
    q_reg[7] <= reset ? 1'b0 : d[7];
end

endmodule