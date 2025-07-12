module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;

// Reset logic
assign next_out = (rst_n) ? (valid_count) ? (out == 4'd11) ? 4'b0000 : out + 1 : out : 4'b0000;

// Counting logic
always_ff @(posedge clk) begin
    out <= next_out;
end

endmodule