module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(*) begin
    if (reset) begin
        next_count = 4'd0;
    end else if (count == 4'd9) begin
        next_count = 4'd0;
    end else begin
        next_count = count + 1'b1;
    end
end

always @(posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule