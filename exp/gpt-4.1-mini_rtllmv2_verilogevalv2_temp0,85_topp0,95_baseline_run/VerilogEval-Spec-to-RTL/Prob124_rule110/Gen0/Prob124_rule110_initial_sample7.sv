module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 as a lookup table (bit 0 corresponds to neighborhood 000)
    // rule110[7:0] = 8'b01101110;
    localparam [7:0] RULE110 = 8'b01101110;

    integer i;
    reg [511:0] q_next;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Left neighbor: q[i+1], except for i=511 where left=0
            // Center: q[i]
            // Right neighbor: q[i-1], except for i=0 where right=0
            // Assemble neighborhood bits: {left, center, right}
            // neighborhood index:
            // bit2 = left, bit1 = center, bit0 = right
            // For out-of-bounds neighbors assign 0
            // Use ternary operators to avoid out-of-bounds

            // Compute neighbors
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            // Neighborhood index
            wire [2:0] idx = {left, center, right};

            // next state for cell i
            q_next[i] = RULE110[idx];
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule