module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg d_prev;  // Previous input value for change detection

always @(posedge clk) begin
    if (q == 0) begin  // Synchronous initialization (replaces initial block)
        q <= 8'b0;
        d_prev <= d;
    end
    else if (d != d_prev) begin  // Only update when input changes
        q <= {d, q[7:1]};  // Combined shift and register update
        d_prev <= d;
    end
end

endmodule