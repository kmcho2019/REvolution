module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg [15:0] gray_count;

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 16'd0;
    end else begin
        if (up_down) begin
            gray_count <= gray_count + 1;
        end else begin
            gray_count <= gray_count - 1;
        end
    end
end

always @(*) begin
    count <= gray_count ^ (gray_count >> 1);
end

endmodule