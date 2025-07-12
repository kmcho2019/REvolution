module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

reg [3:0] count;  // Internal reg to store the count

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'b0000;  // Reset count to 0 if reset is active
    end else if (valid_count) begin
        count <= count + 1;  // Increment count if valid_count is high
    end
end

assign out = count;  // Assign the internal count to the output

endmodule