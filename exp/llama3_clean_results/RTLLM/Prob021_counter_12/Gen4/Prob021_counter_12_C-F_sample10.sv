module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_state;

always_comb begin
    next_state = (!rst_n) ? 4'b0000 : (valid_count && out == 4'd11) ? 4'b0000 : (valid_count) ? out + 1 : out;
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_state;
    end
end

endmodule