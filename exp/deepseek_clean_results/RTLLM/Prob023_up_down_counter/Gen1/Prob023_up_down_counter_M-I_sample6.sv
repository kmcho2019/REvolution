module up_down_counter (
    input clk,
    input reset,
    input enable,       // Added enable for clock gating
    input up_down,
    output reg [15:0] count_gray  // Output in Gray code
);

// Internal binary counter
reg [15:0] count_bin;
wire [15:0] next_count;

// Clock gating logic
wire clk_en = enable | reset;
wire gated_clk = clk & clk_en;

// Binary to Gray code conversion
function [15:0] bin2gray;
    input [15:0] bin;
    begin
        bin2gray = bin ^ (bin >> 1);
    end
endfunction

// Carry-lookahead inspired increment/decrement
assign next_count = up_down ? 
                   count_bin + {15'b0, enable} :  // Increment with enable
                   count_bin - {15'b0, enable};    // Decrement with enable

always @(posedge gated_clk) begin
    if (reset) begin
        count_bin <= 16'b0;
        count_gray <= 16'b0;
    end
    else if (enable) begin
        count_bin <= next_count;
        count_gray <= bin2gray(next_count);
    end
end

endmodule