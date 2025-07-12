module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (|in) begin // Early termination if no bits are set
        casez (in[3:0]) // Lower nibble has priority
            4'b???1: pos = 3'd0;
            4'b??10: pos = 3'd1;
            4'b?100: pos = 3'd2;
            4'b1000: pos = 3'd3;
            default: begin // Check upper nibble
                casez (in[7:4])
                    4'b???1: pos = 3'd4;
                    4'b??10: pos = 3'd5;
                    4'b?100: pos = 3'd6;
                    4'b1000: pos = 3'd7;
                    default: pos = 3'd0; // Shouldn't happen due to |in
                endcase
            end
        endcase
    end else begin
        pos = 3'd0; // No bits set
    end
end

endmodule