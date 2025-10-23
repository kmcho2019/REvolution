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
        bin2gray = {bin[3], bin[3] ^ bin[2], bin[2] ^ bin[1], bin[1] ^ bin[0]};
    end
endfunction

// Gray code to binary conversion (for comparison)
function [3:0] gray2bin;
    input [3:0] gray;
    begin
        gray2bin = {gray[3], 
                   gray[3] ^ gray[2],
                   gray[3] ^ gray[2] ^ gray[1],
                   gray[3] ^ gray[2] ^ gray[1] ^ gray[0]};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        q <= bin2gray(4'b0000);
    end
    else if (slowena) begin
        // Convert to binary for comparison
        if (gray2bin(q) == 4'b1001) begin
            q <= bin2gray(4'b0000);
        end
        else begin
            // Increment in binary domain then convert to Gray
            q <= bin2gray(gray2bin(q) + 1'b1);
        end
    end
end

endmodule