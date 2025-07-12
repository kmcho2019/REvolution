module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    case ({load, ena})
        {1'b1, 2'b??}: q <= data;           // Load has priority
        {1'b0, 2'b01}: q <= {q[0], q[99:1]}; // Right rotate
        {1'b0, 2'b10}: q <= {q[98:0], q[99]}; // Left rotate
        default:       q <= q;              // No rotation
    endcase
end

endmodule