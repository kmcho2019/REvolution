module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [511:0] next_state;
        // Initialize the next state of the first cell
        next_state[0] <= q_reg[1] ^ 1'b0; // Left neighbor is 0
        // Calculate the next state of the cells in the middle
        for (int i = 1; i < 511; i++) begin
            next_state[i] <= q_reg[i-1] ^ q_reg[i+1];
        end
        // Initialize the next state of the last cell
        next_state[511] <= 1'b0 ^ q_reg[510]; // Right neighbor is 0
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule