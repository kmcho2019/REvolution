module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] gray_count;
logic [3:0] binary_count;

// Gray counter implementation
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gray_count <= 4'b0000;
    end else if (valid_count) begin
        gray_count <= gray_count + 1;
    end
end

// Binary conversion
assign binary_count = gray_count ^ (gray_count >> 1);

// Output assignment
assign out = binary_count;

endmodule