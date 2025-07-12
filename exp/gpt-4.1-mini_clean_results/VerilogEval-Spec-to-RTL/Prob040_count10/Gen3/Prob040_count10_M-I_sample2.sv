module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] gray_count;

// Function to convert Gray code to binary
function [3:0] gray_to_bin(input [3:0] gray);
    integer i;
    begin
        gray_to_bin[3] = gray[3];
        for (i = 2; i >= 0; i = i - 1)
            gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
    end
endfunction

// Function to convert binary to Gray code
function [3:0] bin_to_gray(input [3:0] bin);
    begin
        bin_to_gray = (bin >> 1) ^ bin;
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'd0;
        q <= 4'd0;
    end else begin
        // Convert Gray code to binary
        reg [3:0] bin_count = gray_to_bin(gray_count);
        // Increment binary count modulo 10
        if (bin_count == 4'd9)
            bin_count <= 4'd0;
        else
            bin_count <= bin_count + 4'd1;
        // Convert back to Gray code
        gray_count <= bin_to_gray(bin_count);
        q <= bin_count;
    end
end

endmodule