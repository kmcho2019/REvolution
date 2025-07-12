module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

localparam MAX_COUNT = 4'd9;

// Function to calculate next count using arithmetic and conditional logic
function [3:0] next_count;
    input [3:0] curr;
    begin
        next_count = (curr == MAX_COUNT) ? 4'd0 : (curr + 4'd1);
    end
endfunction

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_count(q);
end

endmodule