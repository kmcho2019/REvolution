module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output reg [7:0] q
);

// Synchronous update with enable
always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[7:1]};  // Combine shift and insert in one operation
    end
end

endmodule