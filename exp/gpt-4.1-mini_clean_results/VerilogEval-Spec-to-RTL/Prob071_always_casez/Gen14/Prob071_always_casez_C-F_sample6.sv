module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (in[3:0] != 4'b0000) begin
        // Check lower nibble
        if (in[1:0] != 2'b00) begin
            if (in[0]) pos = 3'd0;
            else        pos = 3'd1;
        end else begin
            if (in[2]) pos = 3'd2;
            else        pos = 3'd3;
        end
    end else if (in[7:4] != 4'b0000) begin
        // Check upper nibble
        if (in[5:4] != 2'b00) begin
            if (in[4]) pos = 3'd4;
            else        pos = 3'd5;
        end else begin
            if (in[6]) pos = 3'd6;
            else        pos = 3'd7;
        end
    end else begin
        // No bits set
        pos = 3'd0;
    end
end

endmodule