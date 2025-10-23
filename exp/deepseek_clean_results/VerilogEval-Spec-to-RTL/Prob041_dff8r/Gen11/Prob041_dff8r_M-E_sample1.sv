module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Mode control (0 = hold, 1 = parallel load, 2 = shift right)
// Fixed to parallel load for this implementation
localparam MODE = 1'b1;

always @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end else begin
        case (MODE)
            1'b0: q <= q;     // Hold state (not used)
            1'b1: q <= d;     // Parallel load
            default: q <= q;  // Default hold
        endcase
    end
end

// Optional clock gating for power optimization
// (Conceptual - would need specific library support)
// assign gated_clk = (reset) ? 1'b0 : clk;

endmodule