// Define the TopModule with the required functionality
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Use always_ff block to describe the behavior of the D flip-flops with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset the flip-flops to 0 on the positive edge of the clock when reset is high
        q <= 8'b0;
    end else begin
        // Otherwise, load the input 'd' into the flip-flops on the positive edge of the clock
        q <= d;
    end
end

endmodule