module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

reg [15:0] q; // Declare q as a reg type so we can assign to it

always @(posedge clk) begin
    if (!resetn) begin // Check for reset condition
        q <= 16'd0; // Reset q to all zeros if resetn is low
    end else begin
        if (byteena[1]) begin // Check if upper byte enable is high
            q[15:8] <= d[15:8]; // Load upper byte of d into q
        end
        if (byteena[0]) begin // Check if lower byte enable is high
            q[7:0] <= d[7:0]; // Load lower byte of d into q
        end
    end
end

endmodule