module right_shifter (
    input clk,
    input reset_n,    // Active-low reset
    input enable,     // Synchronous enable
    input d,          // Input bit
    output reg [7:0] q // Shift register output
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;    // Clear on reset
    end
    else if (enable) begin
        q <= {d, q[7:1]};  // Right shift with new bit in MSB
    end
end

endmodule