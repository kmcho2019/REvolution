module TopModule(
    input clk,
    input reset, // Added reset input
    input [7:0] d,
    output reg [7:0] q = 8'b0 // Initialize q with all zeros
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all bits of q to zero when reset is high
        q <= 8'b0;
    end else begin
        // Assign each bit of d to q at the positive edge of clk
        q <= d;
    end
end

endmodule