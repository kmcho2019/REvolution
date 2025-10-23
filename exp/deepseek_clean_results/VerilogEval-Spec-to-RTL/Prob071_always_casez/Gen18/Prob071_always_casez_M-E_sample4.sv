module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    // Level 1: Check lower half (bits 0-3) vs upper half (bits 4-7)
    if (|in[3:0]) begin
        // Level 2: Check lower quarter (bits 0-1) vs upper quarter (bits 2-3)
        if (|in[1:0]) begin
            // Level 3: Check bit 0 vs bit 1
            if (in[0]) pos = 3'd0;
            else pos = 3'd1;
        end else begin
            // Level 3: Check bit 2 vs bit 3
            if (in[2]) pos = 3'd2;
            else pos = 3'd3;
        end
    end else begin
        // Level 2: Check lower upper quarter (bits 4-5) vs upper upper quarter (bits 6-7)
        if (|in[5:4]) begin
            // Level 3: Check bit 4 vs bit 5
            if (in[4]) pos = 3'd4;
            else pos = 3'd5;
        end else begin
            // Level 3: Check bit 6 vs bit 7
            if (in[6]) pos = 3'd6;
            else pos = 3'd7;
        end
    end
    
    // Handle all-zero case (override if no bits set)
    if (!(|in)) pos = 3'd0;
end

endmodule