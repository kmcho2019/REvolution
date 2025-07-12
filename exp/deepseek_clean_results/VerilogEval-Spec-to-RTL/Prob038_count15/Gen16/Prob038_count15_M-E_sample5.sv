module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] gray_count;
wire [3:0] next_gray;

// Gray code counter increment (XOR-based)
assign next_gray[0] = ~gray_count[0];
assign next_gray[1] = gray_count[1] ^ (gray_count[0] & (&gray_count[3:2]));
assign next_gray[2] = gray_count[2] ^ (gray_count[1] & gray_count[0] & gray_count[3]);
assign next_gray[3] = gray_count[3] ^ (gray_count[2] & gray_count[1] & gray_count[0]);

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'b0000;
    end
    else begin
        gray_count <= next_gray;
    end
end

// Gray to binary conversion
assign q[3] = gray_count[3];
assign q[2] = gray_count[3] ^ gray_count[2];
assign q[1] = gray_count[3] ^ gray_count[2] ^ gray_count[1];
assign q[0] = gray_count[3] ^ gray_count[2] ^ gray_count[1] ^ gray_count[0];

endmodule