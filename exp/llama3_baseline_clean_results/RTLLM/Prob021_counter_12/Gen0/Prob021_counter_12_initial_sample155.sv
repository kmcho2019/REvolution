module counter_12 (
    input  logic        rst_n,       // Reset signal (active low)
    input  logic        clk,         // Clock signal
    input  logic        valid_count, // Signal to enable counting
    output logic [3:0]  out          // 4-bit output representing the current count value
);

logic [3:0] count; // Internal register to store the count value

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Active low reset
        count <= 4'b0000;
    end else if (valid_count) begin // Counting is enabled
        if (count == 4'd11) begin // Wrap around when count reaches 11
            count <= 4'b0000;
        end else begin
            count <= count + 1'b1; // Increment the count
        end
    end // else do nothing when valid_count is 0
end

assign out = count; // Output the current count value

endmodule