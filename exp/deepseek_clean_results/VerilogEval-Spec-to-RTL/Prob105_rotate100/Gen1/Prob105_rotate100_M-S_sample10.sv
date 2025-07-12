module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    case ({load, ena})
        3'b1_xx: q <= data;            // Load has priority
        3'b0_01: q <= {q[0], q[99:1]}; // Right rotate
        3'b0_10: q <= {q[98:0], q[99]};// Left rotate
        default: q <= q;               // No change
    endcase
end

endmodule