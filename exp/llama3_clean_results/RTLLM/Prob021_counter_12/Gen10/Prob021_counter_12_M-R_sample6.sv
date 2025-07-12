module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] count_next;
logic gated_clk;

assign gated_clk = clk & valid_count;

// Combinational logic to calculate the next count value
assign count_next = (valid_count == 1'b1)? (out + 1) : out;

// Flip-flop instantiation with gated clock and reset
always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= count_next;
    end
end

endmodule