module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg wrap_condition;

always @(posedge clk) begin
    wrap_condition <= (q == 4'b1010);  // Pre-compute wrap condition
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;                 // Direct reset assignment
    end
    else if (wrap_condition) begin
        q <= 4'b0001;                  // Wrap around to 1
    end
    else if (q != 4'b1010) begin       // Clock gating condition
        q <= q + 1;                    // Normal increment
    end
end

endmodule