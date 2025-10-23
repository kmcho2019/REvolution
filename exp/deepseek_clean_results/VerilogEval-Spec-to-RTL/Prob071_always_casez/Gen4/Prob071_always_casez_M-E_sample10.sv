module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    // First level: Check lower nibble (bits 0-3)
    if (|in[3:0]) begin
        // Second level: Check lower 2 bits (0-1) vs upper 2 bits (2-3)
        if (|in[1:0]) begin
            // Third level: Check bit 0 vs bit 1
            if (in[0]) pos = 3'd0;
            else pos = 3'd1;
        end else begin
            // Third level: Check bit 2 vs bit 3
            if (in[2]) pos = 3'd2;
            else pos = 3'd3;
        end
    end
    // If no bits in lower nibble, check upper nibble (bits 4-7)
    else begin
        // Second level: Check lower 2 bits (4-5) vs upper 2 bits (6-7)
        if (|in[5:4]) begin
            // Third level: Check bit 4 vs bit 5
            if (in[4]) pos = 3'd4;
            else pos = 3'd5;
        end else begin
            // Third level: Check bit 6 vs bit 7
            if (in[6]) pos = 3'd6;
            else pos = 3'd7;
        end
    end
end

endmodule