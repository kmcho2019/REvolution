module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic gated_clk;
assign gated_clk = valid_count ? clk : 1'b0;

reg [3:0] out_reg;
assign out = out_reg;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out_reg <= 4'b0000;
    end else if (valid_count) begin
        if (out_reg == 4'd11) begin
            out_reg <= 4'b0000;
        end else begin
            out_reg <= out_reg + 1;
        end
    end
end

endmodule