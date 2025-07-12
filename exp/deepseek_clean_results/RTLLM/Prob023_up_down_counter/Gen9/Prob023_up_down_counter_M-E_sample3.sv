module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count  // Gray code output
);

reg [15:0] binary_count;

// Binary to Gray code conversion function
function [15:0] bin2gray;
    input [15:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);
    end
endfunction

// Gray to Binary conversion function (for decrement)
function [15:0] gray2bin;
    input [15:0] gray;
    integer i;
    begin
        gray2bin[15] = gray[15];
        for (i = 14; i >= 0; i = i - 1)
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        binary_count <= 16'b0;
        count <= 16'b0;
    end else begin
        // Update binary counter
        if (up_down)
            binary_count <= binary_count + 1'b1;
        else
            binary_count <= binary_count - 1'b1;
            
        // Convert to Gray code for output
        count <= bin2gray(binary_count);
    end
end

endmodule