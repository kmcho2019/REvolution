module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'b0 // Initialize 'q' to all zeros
);

integer i;
always @(posedge clk) begin // Explicitly specify clock edge sensitivity
    for (i = 0; i < 8; i = i + 1) begin
        q[i] <= d[i]; // Use non-blocking assignment for sequential logic
    end
end

endmodule