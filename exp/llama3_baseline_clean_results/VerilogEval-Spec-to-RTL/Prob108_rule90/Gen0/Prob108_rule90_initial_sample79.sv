module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] q_next;

always @(*) begin
    // Calculate the next state of each cell
    q_next[0] = 0 ^ q_reg[1];  // left boundary is 0
    q_next[511] = q_reg[510] ^ 0;  // right boundary is 0
    for (int i = 1; i < 511; i++) begin
        q_next[i] = q_reg[i-1] ^ q_reg[i+1];
    end
end

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

assign q = q_reg;

endmodule