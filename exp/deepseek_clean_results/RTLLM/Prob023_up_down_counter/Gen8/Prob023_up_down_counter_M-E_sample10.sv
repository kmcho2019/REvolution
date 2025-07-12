module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal Gray code register
reg [15:0] gray_count;

// Binary to Gray code conversion
function [15:0] bin2gray;
    input [15:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);
    end
endfunction

// Gray to Binary conversion
function [15:0] gray2bin;
    input [15:0] gray;
    integer i;
    begin
        gray2bin[15] = gray[15];
        for (i = 14; i >= 0; i = i - 1)
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
    end
endfunction

// Next Gray code calculation
function [15:0] next_gray;
    input [15:0] current_gray;
    input direction;  // 1=up, 0=down
    reg [15:0] binary;
    reg [15:0] next_binary;
    begin
        binary = gray2bin(current_gray);
        next_binary = direction ? binary + 1 : binary - 1;
        next_gray = bin2gray(next_binary);
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 16'b0;  // Gray code 0 is same as binary 0
    end else begin
        gray_count <= next_gray(gray_count, up_down);
    end
end

// Convert Gray code to binary for output
always @(*) begin
    count = gray2bin(gray_count);
end

endmodule