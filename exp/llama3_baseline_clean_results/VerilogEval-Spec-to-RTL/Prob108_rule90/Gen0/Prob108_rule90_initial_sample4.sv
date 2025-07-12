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
            if (i == 0) begin
                left = 0;
            end else begin
                left = q_reg[i-1];
            end
            center = q_reg[i];
            if (i == 511) begin
                right = 0;
            end else begin
                right = q_reg[i+1];
            end
            q_reg[i] <= left ^ right;
        end
    end
end

assign q = q_reg;

endmodule