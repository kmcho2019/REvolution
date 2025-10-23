module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (|in) begin // Early termination if no bits are set
        if (|in[3:0]) begin // Lower nibble has priority
            case (1'b1)
                in[0]: pos = 3'd0;
                in[1]: pos = 3'd1;
                in[2]: pos = 3'd2;
                in[3]: pos = 3'd3;
                default: pos = 3'd0; // Shouldn't happen due to |in[3:0]
            endcase
        end else begin // Upper nibble
            case (1'b1)
                in[4]: pos = 3'd4;
                in[5]: pos = 3'd5;
                in[6]: pos = 3'd6;
                in[7]: pos = 3'd7;
                default: pos = 3'd0; // Shouldn't happen due to |in
            endcase
        end
    end else begin
        pos = 3'd0; // No bits set
    end
end

endmodule