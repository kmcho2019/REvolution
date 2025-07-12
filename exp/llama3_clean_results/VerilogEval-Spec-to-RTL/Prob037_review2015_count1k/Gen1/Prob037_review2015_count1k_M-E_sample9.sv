module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

reg [8:0] lower_bits;

always @ (posedge clk) begin
    if (reset) begin
        lower_bits <= 9'd0; // Reset the lower bits to 0
        q[9] <= 1'b0; // Reset the upper bit to 0
    end else begin
        if (lower_bits == 9'd511) begin
            lower_bits <= 9'd0; // Reset the lower bits to 0 after reaching 511
            q[9] <= ~q[9]; // Toggle the upper bit
        end else begin
            lower_bits <= lower_bits + 1; // Increment the lower bits
        end
        q[8:0] <= lower_bits; // Assign the lower bits to the output
    end
end

endmodule