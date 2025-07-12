module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;
logic gated_clk;

// Clock gating for power reduction
assign gated_clk = clk & valid_count;

// Simplified counting logic with direct wrap-around
always_comb begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        next_out = (out == 4'd11) ? 4'b0000 : out + 1;
    end else begin
        next_out = out;
    end
end

// Sequential logic with gated clock
always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule