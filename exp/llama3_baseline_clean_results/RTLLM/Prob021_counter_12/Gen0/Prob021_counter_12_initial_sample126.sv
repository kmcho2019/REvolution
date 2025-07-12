module counter_12 (
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out;  // Declare out as a reg for assignment

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        out <= 4'b0000;  // Reset out to 0
    end else if (valid_count) begin  // Counting condition
        if (out == 4'd11) begin  // Maximum count reached
            out <= 4'b0000;  // Wrap around to 0
        end else begin
            out <= out + 1;  // Increment out
        end
    end
end

endmodule