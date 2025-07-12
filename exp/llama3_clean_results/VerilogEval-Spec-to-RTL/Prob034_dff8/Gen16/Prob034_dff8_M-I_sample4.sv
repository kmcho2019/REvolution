module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'b0 // Initialize q to all zeros
);

// Define an always block that triggers on the positive edge of the clock
always @(posedge clk) begin
    // Assign each bit of q its corresponding bit from d
    // This ensures that q is updated based on d on each positive clock edge
    q <= d;
end

endmodule