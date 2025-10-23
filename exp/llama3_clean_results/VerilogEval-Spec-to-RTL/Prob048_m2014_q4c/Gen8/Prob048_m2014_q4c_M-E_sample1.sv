module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg next_q; // Local variable to store the next state

always @(posedge clk) begin
    if (r) begin // Check for reset condition
        next_q = 1'b0; // Reset to 0 if r is high
    end else begin
        next_q = d; // Assign d to next_q if r is low
    end
    q <= next_q; // Update q with the next state at posedge clk
end

endmodule