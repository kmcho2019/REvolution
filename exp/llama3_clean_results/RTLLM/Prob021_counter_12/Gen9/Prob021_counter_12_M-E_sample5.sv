module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;

// Asynchronous reset logic
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

// Dynamic clock gating for power reduction
logic gated_clk;
assign gated_clk = clk & valid_count & (out != 4'd11);

// Sequential logic with gated clock and asynchronous reset
always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule