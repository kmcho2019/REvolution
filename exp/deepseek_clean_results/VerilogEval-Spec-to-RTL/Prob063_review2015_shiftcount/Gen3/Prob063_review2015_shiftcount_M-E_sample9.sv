module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Parallel operation paths
wire [3:0] shifted = {q[2:0], data};
wire [3:0] counted = q - 1'b1;

// Operation selection with explicit priority
always @(posedge clk) begin
    casex ({shift_ena, count_ena})
        2'b1x: q <= shifted;    // Shift has priority when both are active
        2'b01: q <= counted;   // Count when only count_ena is active
        default: q <= q;        // Hold state when neither is active
    endcase
end

endmodule