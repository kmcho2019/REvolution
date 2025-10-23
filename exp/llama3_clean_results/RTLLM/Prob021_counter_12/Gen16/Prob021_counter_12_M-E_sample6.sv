module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] count;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'd11;  // Load the counter with the maximum count value
    end else if (valid_count) begin
        if (count == 4'b0000) begin
            count <= 4'd11;  // Wrap around to the maximum count value
        end else begin
            count <= count - 1;  // Decrement the counter
        end
    end
end

assign out = count;

endmodule