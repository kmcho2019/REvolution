// Define the TopModule that implements the DFF functionality directly
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Use an always_ff block to handle the clock edge and reset condition
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset the output to 0 on the positive edge of the clock when reset is high
        q <= 8'b0;
    end else begin
        // Otherwise, load the input 'd' into the output on the positive edge of the clock
        q <= d;
    end
end

endmodule