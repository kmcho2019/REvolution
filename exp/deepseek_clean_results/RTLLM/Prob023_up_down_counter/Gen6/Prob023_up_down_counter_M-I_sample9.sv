module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count
);

reg [15:0] count_reg;
wire [15:0] next_count;

// Gray code conversion
function [15:0] bin2gray;
    input [15:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);
    end
endfunction

// Binary conversion
function [15:0] gray2bin;
    input [15:0] gray;
    reg [15:0] bin;
    integer i;
    begin
        bin[15] = gray[15];
        for (i = 14; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin = bin;
    end
endfunction

// Carry-select style increment/decrement
wire [15:0] count_bin = gray2bin(count_reg);
wire [15:0] next_count_bin = up_down ? 
    {count_bin[15:12] + (count_bin[11:0] == 12'hFFF), 
     count_bin[11:8] + (count_bin[7:0] == 8'hFF),
     count_bin[7:4] + (count_bin[3:0] == 4'hF),
     count_bin[3:0] + 1'b1} :
    {count_bin[15:12] - (count_bin[11:0] == 12'h000), 
     count_bin[11:8] - (count_bin[7:0] == 8'h00),
     count_bin[7:4] - (count_bin[3:0] == 4'h0),
     count_bin[3:0] - 1'b1};

assign next_count = bin2gray(next_count_bin);

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        count_reg <= 16'b0;
    end else begin
        count_reg <= next_count;
    end
end

assign count = gray2bin(count_reg);

endmodule