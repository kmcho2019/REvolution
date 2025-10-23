module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

reg [15:0] gray_count;
reg [15:0] next_gray_count;

// Gray code counter
always @(posedge clk) begin
    if (reset) begin
        gray_count <= 16'd0;
    end else if (up_down) begin
        // Increment Gray code counter
        next_gray_count <= gray_count + 1;
        gray_count <= next_gray_count;
    end else begin
        // Decrement Gray code counter
        next_gray_count <= gray_count - 1;
        gray_count <= next_gray_count;
    end
end

// Convert Gray code to binary
always @(*) begin
    count = gray_count ^ (gray_count >> 1);
end

endmodule