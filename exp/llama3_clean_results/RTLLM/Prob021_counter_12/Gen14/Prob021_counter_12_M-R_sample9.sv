module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;
assign next_out = (out == 4'd11)? 4'b0000 : out + 1;

logic gated_clk;
assign gated_clk = clk & valid_count;

always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule