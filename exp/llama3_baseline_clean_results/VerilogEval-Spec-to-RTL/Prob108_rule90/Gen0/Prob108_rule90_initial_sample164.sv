module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] q_next;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

always @(*) begin
    q_next = q_reg;
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = q_reg[i-1];
        end
        center = q_reg[i];
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = q_reg[i+1];
        end
        q_next[i] = left ^ right;
    end
end

assign q = q_reg;

endmodule