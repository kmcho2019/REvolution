module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Use 8 D flip-flops with active high synchronous reset
always @(posedge clk) begin
    if (reset) begin
        // If reset is high, reset all outputs to zero
        q <= 8'b0;
    end else begin
        // Otherwise, update outputs with current inputs
        q <= d;
    end
end

endmodule