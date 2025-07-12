module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;
logic clk_gated;

// Clock gating
assign clk_gated = valid_count && rst_n;

// Next state logic
always_comb begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        if (out == 4'd11) begin
            next_out = 4'b0000;
        end else begin
            next_out = out + 1;
        end
    end else begin
        next_out = out;
    end
end

// Sequential logic
always_ff @(posedge clk) begin
    if (clk_gated) begin
        out <= next_out;
    end
end

endmodule