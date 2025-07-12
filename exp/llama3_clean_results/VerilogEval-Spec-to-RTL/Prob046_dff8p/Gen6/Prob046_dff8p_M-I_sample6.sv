module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] d_sync; // Synchronization stage for input data
reg [7:0] q_reg;

// Synchronize input data with the clock edge
always @(posedge clk) begin
    d_sync <= d;
end

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34;
    end else begin
        q_reg <= d_sync; // Use synchronized input data
    end
end

assign q = q_reg;

endmodule