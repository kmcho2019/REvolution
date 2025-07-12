module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q = 16'd0 // Initialize output to zero
);

// Always block triggered by the positive edge of the clock
always @(posedge clk) begin
    if (!resetn) begin // Synchronous reset
        q <= 16'd0; // Reset all bits to zero
    end else begin
        if (byteena[0]) begin // Update lower byte if enabled
            q[7:0] <= d[7:0];
        end
        if (byteena[1]) begin // Update upper byte if enabled
            q[15:8] <= d[15:8];
        end
    end
end

endmodule