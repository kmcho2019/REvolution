module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (in == 8'b0) begin
        pos = 3'd0;  // No bits set
    end else if (in[3:0] != 4'b0) begin
        // Check lower nibble first
        if (in[1:0] != 2'b0) begin
            pos = in[0] ? 3'd0 : 3'd1;
        end else begin
            pos = in[2] ? 3'd2 : 3'd3;
        end
    end else begin
        // Upper nibble is not zero
        if (in[5:4] != 2'b0) begin
            pos = in[4] ? 3'd4 : 3'd5;
        end else begin
            pos = in[6] ? 3'd6 : 3'd7;
        end
    end
end

endmodule