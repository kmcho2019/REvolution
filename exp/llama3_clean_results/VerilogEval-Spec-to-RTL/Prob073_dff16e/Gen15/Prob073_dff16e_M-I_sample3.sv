// Define the top-level module
module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Use an always block to handle the positive edge of the clock
always @(posedge clk) begin
    // Prioritize the reset condition for synchronous reset
    if (~resetn) begin
        // Reset the output to zero
        q <= 16'd0;
    end else begin
        // If byteena[1] is set, update the upper byte
        if (byteena[1]) begin
            q[15:8] <= d[15:8];
        end
        // If byteena[0] is set, update the lower byte
        if (byteena[0]) begin
            q[7:0] <= d[7:0];
        end
    end
end

endmodule