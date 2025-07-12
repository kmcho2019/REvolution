module right_shifter (
    input wire clk,
    input wire reset_n,    // Active-low reset
    input wire enable,     // Synchronous enable
    input wire d,          // Input bit
    output reg [7:0] q     // Shift register output
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 8'b0;         // Synchronous reset
    end
    else if (enable) begin
        q <= {d, q[7:1]};  // Efficient right shift with new bit insertion
    end
end

endmodule