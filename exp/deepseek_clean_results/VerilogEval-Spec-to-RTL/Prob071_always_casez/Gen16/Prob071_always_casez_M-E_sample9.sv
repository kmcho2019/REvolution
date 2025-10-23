module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    // Level 1: Split into two 4-bit halves
    if (|in[3:0]) begin
        // Level 2: Split lower nibble into two 2-bit halves
        if (|in[1:0]) begin
            // Level 3: Check individual bits in lower 2 bits
            pos = in[0] ? 3'd0 : 3'd1;
        end else begin
            // Level 3: Check individual bits in upper 2 bits of lower nibble
            pos = in[2] ? 3'd2 : 3'd3;
        end
    end else if (|in[7:4]) begin
        // Level 2: Split upper nibble into two 2-bit halves
        if (|in[5:4]) begin
            // Level 3: Check individual bits in lower 2 bits of upper nibble
            pos = in[4] ? 3'd4 : 3'd5;
        end else begin
            // Level 3: Check individual bits in upper 2 bits of upper nibble
            pos = in[6] ? 3'd6 : 3'd7;
        end
    end else begin
        // No bits set
        pos = 3'd0;
    end
end

endmodule