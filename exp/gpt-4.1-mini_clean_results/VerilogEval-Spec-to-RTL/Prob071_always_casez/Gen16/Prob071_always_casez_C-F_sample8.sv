module TopModule(
    input  [7:0] in,
    output reg [2:0] pos
);

always @(*) begin
    if (in == 8'b0) begin
        pos = 3'd0;  // No bits set
    end else if (in[3:0] != 4'b0) begin
        // Check lower nibble
        if (in[1:0] != 2'b0) begin
            if (in[0]) pos = 3'd0;
            else       pos = 3'd1;
        end else begin
            if (in[2]) pos = 3'd2;
            else       pos = 3'd3;
        end
    end else begin
        // Check upper nibble
        if (in[5:4] != 2'b0) begin
            if (in[4]) pos = 3'd4;
            else       pos = 3'd5;
        end else begin
            if (in[6]) pos = 3'd6;
            else       pos = 3'd7;
        end
    end
end

endmodule