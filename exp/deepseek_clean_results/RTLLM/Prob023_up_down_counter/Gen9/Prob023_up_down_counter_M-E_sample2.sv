module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal Gray code representation
reg [15:0] gray_count;

// Binary to Gray conversion
function [15:0] bin2gray;
    input [15:0] binary;
    begin
        bin2gray = binary ^ (binary >> 1);
    end
endfunction

// Gray to binary conversion
function [15:0] gray2bin;
    input [15:0] gray;
    integer i;
    begin
        gray2bin[15] = gray[15];
        for (i = 14; i >= 0; i = i - 1)
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
    end
endfunction

// Next Gray code state logic
function [15:0] next_gray;
    input [15:0] current;
    input direction;  // 1=up, 0=down
    reg [15:0] binary;
    begin
        binary = gray2bin(current);
        if (direction)
            binary = binary + 1'b1;
        else
            binary = binary - 1'b1;
        next_gray = bin2gray(binary);
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 16'b0;
        count <= 16'b0;
    end else begin
        gray_count <= next_gray(gray_count, up_down);
        count <= gray2bin(gray_count);
    end
end

endmodule