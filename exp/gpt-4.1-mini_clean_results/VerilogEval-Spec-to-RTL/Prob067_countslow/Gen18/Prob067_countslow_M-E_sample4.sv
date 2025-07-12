module TopModule (
    input        clk,
    input        reset,
    input        slowena,
    output reg [3:0] q
);

// Gray code counter register (4 bits)
reg [3:0] gray_count;

// Function to convert Gray code to binary
function [3:0] gray_to_bin;
    input [3:0] gray;
    begin
        gray_to_bin[3] = gray[3];
        gray_to_bin[2] = gray[3] ^ gray[2];
        gray_to_bin[1] = gray_to_bin[2] ^ gray[1];
        gray_to_bin[0] = gray_to_bin[1] ^ gray[0];
    end
endfunction

// Function to convert binary to Gray code
function [3:0] bin_to_gray;
    input [3:0] bin;
    begin
        bin_to_gray[3] = bin[3];
        bin_to_gray[2] = bin[3] ^ bin[2];
        bin_to_gray[1] = bin[2] ^ bin[1];
        bin_to_gray[0] = bin[1] ^ bin[0];
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'd0; // Gray code zero
    end else if (slowena) begin
        // Convert gray_count to binary
        reg [3:0] bin_count;
        bin_count = gray_to_bin(gray_count);

        // Increment and wrap at 9
        if (bin_count == 4'd9) begin
            gray_count <= bin_to_gray(4'd0);
        end else begin
            gray_count <= bin_to_gray(bin_count + 4'd1);
        end
    end
    // else hold gray_count
end

// Output q is binary conversion of gray_count
always @(*) begin
    q = gray_to_bin(gray_count);
end

endmodule