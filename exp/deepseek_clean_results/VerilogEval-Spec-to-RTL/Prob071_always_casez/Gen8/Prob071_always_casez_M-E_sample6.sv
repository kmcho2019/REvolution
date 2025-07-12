module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (|in[3:0]) begin  // Check lower nibble first
        if (|in[1:0]) begin  // Check lower pair
            pos = in[0] ? 3'd0 : 3'd1;
        end else begin       // Upper pair of lower nibble
            pos = in[2] ? 3'd2 : 3'd3;
        end
    end else begin         // Check upper nibble
        if (|in[5:4]) begin  // Check lower pair of upper nibble
            pos = in[4] ? 3'd4 : 3'd5;
        end else begin       // Check upper pair of upper nibble
            pos = in[6] ? 3'd6 : 3'd7;
        end
    end
end

endmodule