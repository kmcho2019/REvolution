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
        // If enabled, update the upper byte of the output with the input data
        if (byteena[1]) begin
            q[15:8] <= d[15:8];
        end
        // If enabled, update the lower byte of the output with the input data
        if (byteena[0]) begin
            q[7:0] <= d[7:0];
        end
    end
end

endmodule