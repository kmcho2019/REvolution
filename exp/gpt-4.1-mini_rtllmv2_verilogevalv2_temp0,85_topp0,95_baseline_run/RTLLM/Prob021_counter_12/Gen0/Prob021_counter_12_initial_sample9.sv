module counter_12 (
    input  wire       rst_n,       // Active low reset
    input  wire       clk,         // Clock input
    input  wire       valid_count, // Enable counting
    output reg [3:0]  out          // 4-bit counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;            // Reset counter to 0 when rst_n is low
    else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'b0000;        // Wrap around to 0 when count reaches 11
        else
            out <= out + 1'b1;     // Increment counter
    end
    // else: hold the current value when valid_count == 0
end

endmodule