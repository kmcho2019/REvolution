module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    // First level: Check lower 4 bits (0-3)
    if (|in[3:0]) begin
        // Second level: Check lower 2 bits (0-1)
        if (|in[1:0]) begin
            // Third level: Check bit 0
            pos = in[0] ? 3'd0 : 3'd1;
        end else begin
            // Third level: Check bit 2
            pos = in[2] ? 3'd2 : 3'd3;
        end
    end
    // First level: Check upper 4 bits (4-7)
    else if (|in[7:4]) begin
        // Second level: Check lower 2 bits (4-5)
        if (|in[5:4]) begin
            // Third level: Check bit 4
            pos = in[4] ? 3'd4 : 3'd5;
        end else begin
            // Third level: Check bit 6
            pos = in[6] ? 3'd6 : 3'd7;
        end
    end
    else begin
        pos = 3'd0;
    end
end

endmodule