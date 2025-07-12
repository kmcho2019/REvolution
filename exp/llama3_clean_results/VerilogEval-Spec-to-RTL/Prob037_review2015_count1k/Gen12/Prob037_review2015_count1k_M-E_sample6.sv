module TopModule(
    input  clk,
    input  reset,
    output [9:0] q
);

reg [6:0] msb_count;
reg [2:0] lsb_count;

always @(posedge clk) begin
    if (reset) begin
        msb_count <= 7'd0;
        lsb_count <= 3'd0;
    end else if (lsb_count == 3'd7) begin
        msb_count <= msb_count + 7'd1;
        lsb_count <= 3'd0;
    end else begin
        lsb_count <= lsb_count + 3'd1;
    end
    
    if (msb_count == 7'd125 && lsb_count == 3'd7) begin
        msb_count <= 7'd0;
        lsb_count <= 3'd0;
    end
end

assign q = {msb_count, lsb_count};

endmodule