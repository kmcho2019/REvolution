module TopModule(
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
        reg [511:0] q_next;
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                q_next[i] <= q_reg[1];
            end else if (i == 511) begin
                q_next[i] <= q_reg[510];
            end else begin
                q_next[i] <= q_reg[i - 1] ^ q_reg[i + 1];
            end
        end
        q_reg <= q_next;
    end
end

assign q = q_reg;

endmodule