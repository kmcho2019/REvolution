module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] gray_count;

// Gray code increment logic
wire [3:0] next_gray;
assign next_gray = gray_count ^ ({1'b0, gray_count[3:1]} + 1'b1);

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'b0000;
    end else begin
        gray_count <= next_gray;
    end
end

// Gray to binary conversion
assign q = {gray_count[3],
            gray_count[3] ^ gray_count[2],
            gray_count[3] ^ gray_count[2] ^ gray_count[1],
            gray_count[3] ^ gray_count[2] ^ gray_count[1] ^ gray_count[0]};

endmodule