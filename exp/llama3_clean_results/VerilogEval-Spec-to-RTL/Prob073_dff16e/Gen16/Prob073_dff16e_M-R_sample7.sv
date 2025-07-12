module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (~resetn) begin
        // Reset all bits to zero
        q <= 16'd0;
    end else begin
        // Update the upper byte if byteena[1] is high
        if (byteena[1]) begin
            q[15:8] <= d[15:8];
        end else begin
            // Otherwise, retain the current value of the upper byte
            q[15:8] <= q[15:8];
        end
        
        // Update the lower byte if byteena[0] is high
        if (byteena[0]) begin
            q[7:0] <= d[7:0];
        end else begin
            // Otherwise, retain the current value of the lower byte
            q[7:0] <= q[7:0];
        end
    end
end

endmodule