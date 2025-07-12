module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Continuous assignment for calculating the next state of all cells
wire [511:0] q_next;

assign q_next[0] = 1'b0 ^ q_reg[1]; // Left boundary is 0
for (genvar i = 1; i < 511; i++) begin
    assign q_next[i] = q_reg[i-1] ^ q_reg[i+1];
end
assign q_next[511] = q_reg[510] ^ 1'b0; // Right boundary is 0

// Update the state register on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

assign q = q_reg;

endmodule