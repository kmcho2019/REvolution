module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;

// Combinatorial logic to calculate the next state
always_comb begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        next_out = out + 1;
    end else begin
        next_out = out;
    end
end

// Sequential logic to update the output register
always_ff @(posedge clk) begin
    out <= next_out;
end

endmodule