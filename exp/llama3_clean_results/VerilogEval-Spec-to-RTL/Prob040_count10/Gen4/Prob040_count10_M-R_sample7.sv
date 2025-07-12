module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(*) begin
    if (count == 4'd9) begin
        next_count = 4'd0;
    end else begin
        next_count = count + 4'd1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else begin
        count <= next_count;
    end
end

assign q = count;

endmodule