module up_down_counter (
    input clk,
    input reset,
    input up_down,
    input enable,
    output reg [15:0] count
);

// Internal Gray code representation
reg [15:0] gray_count;

// Binary to Gray conversion
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

// 4-bit counter slices with carry lookahead
wire [3:0] carry;
assign carry[0] = enable;

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : counter_slice
        always @(posedge clk) begin
            if (reset) begin
                gray_count[i*4 +: 4] <= 0;
            end
            else if (carry[i]) begin
                if (up_down)
                    gray_count[i*4 +: 4] <= gray_count[i*4 +: 4] + 1;
                else
                    gray_count[i*4 +: 4] <= gray_count[i*4 +: 4] - 1;
            end
        end
        
        if (i < 3) begin
            // Carry lookahead logic
            assign carry[i+1] = carry[i] & ((up_down & (&gray_count[i*4 +: 4])) | 
                                              (!up_down & ~(|gray_count[i*4 +: 4])));
        end
    end
endgenerate

// Convert Gray code to binary output
always @(*) begin
    count = gray2bin(gray_count);
end

endmodule