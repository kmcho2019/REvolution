module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    // Level 1: Check lower 4 bits vs upper 4 bits
    if (|in[3:0]) begin
        // Level 2: Check lower 2 bits vs upper 2 bits of lower nibble
        if (|in[1:0]) begin
            // Level 3: Check bit 0 vs bit 1
            pos = in[0] ? 3'd0 : 3'd1;
        end else begin
            // Level 3: Check bit 2 vs bit 3
            pos = in[2] ? 3'd2 : 3'd3;
        end
    end else begin
        // Level 2: Check lower 2 bits vs upper 2 bits of upper nibble
        if (|in[5:4]) begin
            // Level 3: Check bit 4 vs bit 5
            pos = in[4] ? 3'd4 : 3'd5;
        end else begin
            // Level 3: Check bit 6 vs bit 7
            pos = in[6] ? 3'd6 : 3'd7;
        end
    end
    
    // Handle all zeros case
    if (!(|in)) pos = 3'd0;
end

endmodule