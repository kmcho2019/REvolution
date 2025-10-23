module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,  // Synchronous enable control
    output reg [7:0] q
);

// Synchronous shift operation with enable
always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[7:1]};  // Efficient concatenation-based shift
    end
end

endmodule