module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    // Explicit byte mask for clarity and synthesis friendliness
    wire [15:0] mask = {
        (byteena[1] ? 8'hFF : 8'h00),
        (byteena[0] ? 8'hFF : 8'h00)
    };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Update each byte conditionally using mask, preserving bits not enabled
            // This merges the mask-driven bit-wise operation with conditional byte updates
            // to minimize logic depth and toggling.
            q <= (q & ~mask) | (d & mask);
        end
    end

endmodule