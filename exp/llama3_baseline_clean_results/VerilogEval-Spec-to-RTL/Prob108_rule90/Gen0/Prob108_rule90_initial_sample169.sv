module TopModule (
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [511:0] next_state;
        next_state[0] <= q_reg[1] ^ 1'b0;  // left neighbor is 0 for first cell
        next_state[511] <= q_reg[510] ^ 1'b0;  // right neighbor is 0 for last cell
        for (int i = 1; i < 511; i++) begin
            next_state[i] <= q_reg[i-1] ^ q_reg[i+1];
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule