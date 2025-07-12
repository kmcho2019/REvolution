module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Internal gray code counter register
reg [3:0] gray_q;

// Function to convert gray to binary
function [3:0] gray_to_binary;
    input [3:0] gray;
    integer i;
    begin
        gray_to_binary[3] = gray[3];
        for (i = 2; i >= 0; i = i - 1) begin
            gray_to_binary[i] = gray_to_binary[i+1] ^ gray[i];
        end
    end
endfunction

// Gray code increment: next_gray = gray_q ^ (1 << lsb_set_bit_position)
// For gray counting up by 1, next gray code = gray_q ^ (gray_q + 1)
// But simpler is to generate next gray code by adding 1 to binary count and convert to gray:
// To avoid binary add, we increment binary counter internally and convert to gray, but we want to save switching.

// To minimize logic, do gray_q <= next_gray; where next_gray = gray_q + 1 in gray code sequence

// For simplicity and best power, use binary count internally, convert to gray for storage, and convert back for output

reg [3:0] bin_count;

always @(posedge clk) begin
    if (reset) begin
        bin_count <= 4'd0;
    end else begin
        bin_count <= bin_count + 1'b1;
    end
end

// Convert binary count to gray for storage (register toggling)
wire [3:0] next_gray = bin_count ^ (bin_count >> 1);

always @(posedge clk) begin
    if (reset) begin
        gray_q <= 4'd0;
    end else begin
        gray_q <= next_gray;
    end
end

// Output decoded binary from gray counter (which matches bin_count)
always @(*) begin
    q = gray_to_binary(gray_q);
end

endmodule