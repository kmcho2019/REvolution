module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Generate individual bit enables from byte enables
wire [15:0] bit_enable = {
    {8{byteena[1]}},  // Upper byte enable replicated 8 times
    {8{byteena[0]}}   // Lower byte enable replicated 8 times
};

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Update only enabled bits
        for (integer i = 0; i < 16; i = i + 1) begin
            if (bit_enable[i]) begin
                q[i] <= d[i];
            end
        end
    end
end

endmodule