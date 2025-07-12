module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    // Level 1: Check if any bits are set
    if (|in) begin
        // Level 2: Check lower half (bits 0-3) first
        if (|in[3:0]) begin
            // Level 3: Check lower nibble's lower half (bits 0-1)
            if (|in[1:0]) begin
                // Leaf: Check individual bits
                pos = in[0] ? 3'd0 : 3'd1;
            end else begin
                // Leaf: Check individual bits
                pos = in[2] ? 3'd2 : 3'd3;
            end
        end else begin
            // Level 3: Check upper nibble's lower half (bits 4-5)
            if (|in[5:4]) begin
                // Leaf: Check individual bits
                pos = in[4] ? 3'd4 : 3'd5;
            end else begin
                // Leaf: Check individual bits
                pos = in[6] ? 3'd6 : 3'd7;
            end
        end
    end else begin
        pos = 3'd0; // No bits set
    end
end

endmodule