// Improved TopModule focusing on synthesizability, correct functionality, and PPA optimization
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'd0 // Initialize output 'q' with a default value
);

// Use non-blocking assignment for edge-triggered behavior at positive clock edge
always @(posedge clk) begin
    if (d != q) begin // Only update 'q' if 'd' has changed
        q <= d; // Assign input 'd' to output 'q' at each positive clock edge
    end
end

endmodule