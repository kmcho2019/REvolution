module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

always_ff @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        if (out == 4'd11) begin
            out <= 4'b0000;
        end else begin
            out <= out + 1;
        end
    end
end

endmodule