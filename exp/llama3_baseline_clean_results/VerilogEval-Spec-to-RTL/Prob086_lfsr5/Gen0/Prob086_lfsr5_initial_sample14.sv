module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 5'b10000; // Set MSB to 1 on reset
    end else begin
        q_reg <= {q_reg[3:0], (q_reg[4] ^ q_reg[2] ^ q_reg[0])}; // Update state
    end
end

assign q = q_reg;

endmodule