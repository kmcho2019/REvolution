module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Reset q to 0 when reset is active high
    end else begin
        q <= q + 1; // Increment q on each clock cycle when reset is not active
    end
end

endmodule