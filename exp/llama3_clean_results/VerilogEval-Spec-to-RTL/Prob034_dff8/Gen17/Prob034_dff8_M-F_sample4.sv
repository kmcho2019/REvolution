module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Initialize q to all zeros
initial begin
    q = 8'b0;
end

// Define an always block that triggers on the positive edge of the clock
always @(posedge clk) begin
    // Explicitly update each bit of q based on the corresponding bit of d
    // This ensures that q is updated on each positive clock edge, reflecting the behavior of 8 D flip-flops
    for (int i = 0; i < 8; i++) begin
        q[i] <= d[i];
    end
end

endmodule