module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] out_next;

// Next state logic
assign out_next = (!rst_n) ? 4'b0000 : (valid_count) ? out + 1 : out;

// Output logic with gated clock
always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= out + 1;
    end
end

endmodule