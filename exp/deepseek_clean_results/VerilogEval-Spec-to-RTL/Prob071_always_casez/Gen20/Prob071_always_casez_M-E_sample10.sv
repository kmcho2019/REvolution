module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    // Level 1: Split into two 4-bit halves
    if (|in[3:0]) begin
        // Level 2: Lower nibble split into two 2-bit quarters
        if (|in[1:0]) begin
            // Level 3: Check individual bits
            if (in[0]) pos = 3'd0;
            else if (in[1]) pos = 3'd1;
            else pos = 3'd0; // Shouldn't happen due to |in[1:0]
        end else begin
            // Level 3: Check individual bits
            if (in[2]) pos = 3'd2;
            else if (in[3]) pos = 3'd3;
            else pos = 3'd0; // Shouldn't happen due to |in[3:0]
        end
    end else begin
        // Level 2: Upper nibble split into two 2-bit quarters
        if (|in[5:4]) begin
            // Level 3: Check individual bits
            if (in[4]) pos = 3'd4;
            else if (in[5]) pos = 3'd5;
            else pos = 3'd0; // Shouldn't happen due to |in[5:4]
        end else begin
            // Level 3: Check individual bits
            if (in[6]) pos = 3'd6;
            else if (in[7]) pos = 3'd7;
            else pos = 3'd0; // No bits set
        end
    end
end

endmodule