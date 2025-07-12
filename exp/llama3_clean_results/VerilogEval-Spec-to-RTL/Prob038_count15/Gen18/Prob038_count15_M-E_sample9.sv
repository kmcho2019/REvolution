module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Reset the counter to 0
        q <= 4'd0;
    end else begin
        // Implement the Johnson counter logic
        // The LSB is inverted and fed back to the MSB
        q <= {~q[0], q[3:1]};
    end
end

endmodule