module right_shifter (
    input wire clk,
    input wire d,
    input wire shift_en,  // Shift control signal
    input wire reset_n,   // Active-low synchronous reset
    output reg [7:0] q    // Direct register output
);

always @(posedge clk) begin
    if (!reset_n) begin
        q <= 8'b0;        // Synchronous reset
    end
    else if (shift_en) begin
        q <= {d, q[7:1]}; // Right shift with new MSB
    end
    // Else maintain current value (implicit)
end

endmodule