module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Binary to Gray code conversion
function [3:0] bin2gray;
    input [3:0] bin;
    begin
        bin2gray = {bin[3], bin[3:1] ^ bin[2:0]};
    end
endfunction

// Gray code to binary conversion
function [3:0] gray2bin;
    input [3:0] gray;
    begin
        gray2bin[3] = gray[3];
        gray2bin[2] = gray[3] ^ gray[2];
        gray2bin[1] = gray[3] ^ gray[2] ^ gray[1];
        gray2bin[0] = gray[3] ^ gray[2] ^ gray[1] ^ gray[0];
    end
endfunction

reg [3:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        q <= next_q;
    end
end

always @(*) begin
    if (gray2bin(q) == 4'b1001) begin  // Terminal count (9)
        next_q = bin2gray(4'b0000);    // Wrap around to 0
    end
    else begin
        next_q = bin2gray(gray2bin(q) + 1'b1);  // Increment in binary, convert to Gray
    end
end

endmodule