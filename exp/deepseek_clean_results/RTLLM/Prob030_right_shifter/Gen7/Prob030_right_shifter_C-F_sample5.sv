module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,  // Synchronous enable
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[7:1]};  // Right shift and insert new bit in MSB
    end
    // else hold current value (implicit)
end

endmodule