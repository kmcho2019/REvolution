module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [9:0] gray_count;
wire count_enable = (gray_count != 10'b1111100111); // Gray code of 999

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 10'b0;
    end else if (count_enable) begin
        // Binary to Gray conversion: gray = binary ^ (binary >> 1)
        gray_count <= (gray_count ^ (gray_count >> 1)) + 1'b1;
        gray_count <= gray_count ^ ((gray_count ^ (gray_count >> 1)) + 1'b1) >> 1;
    end
end

// Gray to binary conversion for output
always @(*) begin
    q[9] = gray_count[9];
    q[8] = gray_count[8] ^ q[9];
    q[7] = gray_count[7] ^ q[8];
    q[6] = gray_count[6] ^ q[7];
    q[5] = gray_count[5] ^ q[6];
    q[4] = gray_count[4] ^ q[5];
    q[3] = gray_count[3] ^ q[4];
    q[2] = gray_count[2] ^ q[3];
    q[1] = gray_count[1] ^ q[2];
    q[0] = gray_count[0] ^ q[1];
end

endmodule