module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] gray_count;

// Gray code counter logic
always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'b0000;
    end
    else begin
        // Standard Gray code increment using XOR feedback
        gray_count <= gray_count + 4'b0001;
        gray_count[3] <= gray_count[3] ^ (&gray_count[2:0]);
    end
end

// Gray to binary conversion
assign q[3] = gray_count[3];
assign q[2] = gray_count[3] ^ gray_count[2];
assign q[1] = gray_count[3] ^ gray_count[2] ^ gray_count[1];
assign q[0] = gray_count[3] ^ gray_count[2] ^ gray_count[1] ^ gray_count[0];

endmodule