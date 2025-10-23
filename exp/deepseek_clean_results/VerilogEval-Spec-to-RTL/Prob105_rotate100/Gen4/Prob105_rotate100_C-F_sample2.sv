module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        // Synchronous load has highest priority
        q <= data;
    end else if (ena != 2'b00 && ena != 2'b11) begin
        // Only perform rotation when ena indicates valid operation
        case (ena)
            2'b01: q <= {q[0], q[99:1]};    // Right rotate: LSB moves to MSB
            2'b10: q <= {q[98:0], q[99]};    // Left rotate: MSB moves to LSB
            default: q <= q;                 // Should never reach here due to if condition
        endcase
    end
    // For ena=00 or 11, q remains unchanged (implicit)
end

endmodule