module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Internal Gray code register
reg [3:0] gray_q;
reg [3:0] next_gray_q;

// Function to convert Gray code to binary (4-bit)
function [3:0] gray_to_binary;
    input [3:0] gray;
    begin
        gray_to_binary[3] = gray[3];
        gray_to_binary[2] = gray[3] ^ gray[2];
        gray_to_binary[1] = gray_to_binary[2] ^ gray[1];
        gray_to_binary[0] = gray_to_binary[1] ^ gray[0];
    end
endfunction

// Next Gray code increment: gray_q + 1 in Gray code sequence
// Gray code increment pattern: next_gray_q = gray_q ^ (1 << lsb_zero_position_in_gray_q)
// but simpler to implement by binary count increment + conversion to Gray code
// To avoid adding binary adders, we increment binary count and convert to Gray.

reg [3:0] binary_counter;

always @(*) begin
    binary_counter = gray_to_binary(gray_q) + 1;
    next_gray_q = binary_counter ^ (binary_counter >> 1);
end

always @(posedge clk) begin
    if (reset) begin
        gray_q <= 4'b0000;
        q <= 4'b0000;
    end else begin
        gray_q <= next_gray_q;
        q <= gray_to_binary(next_gray_q);
    end
end

endmodule