module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Highest priority: synchronous load
    end else begin
        case (ena)
            2'b01: q <= {q[0], q[99:1]};    // Right rotate: LSB moves to MSB
            2'b10: q <= {q[98:0], q[99]};   // Left rotate: MSB moves to LSB
            2'b00, 2'b11: q <= q;           // No rotation (explicit cases)
            default: q <= q;                // Catch-all for synthesis
        endcase
    end
end

endmodule