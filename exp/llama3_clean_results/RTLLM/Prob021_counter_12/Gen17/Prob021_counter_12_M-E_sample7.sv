module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] count;
logic clk_enable;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'b0000;
        clk_enable <= 1'b0;
    end else begin
        if (valid_count && count < 4'd11) begin
            count <= count + 1;
            clk_enable <= 1'b1;
        end else if (!valid_count || count == 4'd11) begin
            clk_enable <= 1'b0;
        end
    end
end

always_comb begin
    if (clk_enable) begin
        out = count;
    end else begin
        out = count;
    end
end

endmodule