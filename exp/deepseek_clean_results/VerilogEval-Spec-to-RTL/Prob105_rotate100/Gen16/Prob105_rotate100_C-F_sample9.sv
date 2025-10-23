module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Highest priority synchronous load
    end else begin
        case (ena)
            2'b01: q <= {q[0], q[99:1]};  // Right rotate (computed only when needed)
            2'b10: q <= {q[98:0], q[99]};  // Left rotate (computed only when needed)
            default: q <= q;               // No rotation (no computation)
        endcase
    end
end

endmodule