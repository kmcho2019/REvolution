module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

parameter WIDTH = 4;
parameter MAX_COUNT = 9;

reg [WIDTH-1:0] count;
reg gated_clk;

// Clock gating logic
always @(*) begin
    gated_clk = clk & (slowena | reset);
end

// Binary to Gray conversion
function [WIDTH-1:0] bin2gray;
    input [WIDTH-1:0] bin;
    bin2gray = bin ^ (bin >> 1);
endfunction

// Sequential logic with gated clock
always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        count <= 0;
    end else begin
        count <= (count == MAX_COUNT) ? 0 : count + 1;
    end
end

assign q = bin2gray(count);

endmodule