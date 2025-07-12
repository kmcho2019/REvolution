module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input valid_count,  // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out;  // Declare output register

always @(posedge clk or negedge rst_n)  // Synchronous reset
begin
    if (!rst_n)  // Active low reset
    begin
        out <= 4'b0000;  // Reset output register to 0
    end
    else  // If not in reset
    begin
        if (valid_count)  // Check if valid_count signal is 1
        begin
            if (out == 4'd11)  // Check if current count value is 4'd11
            begin
                out <= 4'b0000;  // Wrap around to 0
            end
            else
            begin
                out <= out + 1;  // Increment output register by 1
            end
        end
        // If valid_count is 0, output register remains unchanged
    end
end

endmodule