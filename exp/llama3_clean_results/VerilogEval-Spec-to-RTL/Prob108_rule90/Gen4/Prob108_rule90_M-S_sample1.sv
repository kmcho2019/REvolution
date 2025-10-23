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
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            left = (i == 0) ? 1'b0 : q_reg[i-1];
            center = q_reg[i];
            right = (i == 511) ? 1'b0 : q_reg[i+1];
            q_reg[i] <= left ^ right;
        end
    end
end

assign q = q_reg;

endmodule