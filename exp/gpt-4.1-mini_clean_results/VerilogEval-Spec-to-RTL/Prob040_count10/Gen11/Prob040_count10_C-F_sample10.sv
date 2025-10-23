module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Function encapsulating the next state logic with explicit enumeration for clarity and ease of modification
function [3:0] next_count;
    input [3:0] curr;
    begin
        case (curr)
            4'd0: next_count = 4'd1;
            4'd1: next_count = 4'd2;
            4'd2: next_count = 4'd3;
            4'd3: next_count = 4'd4;
            4'd4: next_count = 4'd5;
            4'd5: next_count = 4'd6;
            4'd6: next_count = 4'd7;
            4'd7: next_count = 4'd8;
            4'd8: next_count = 4'd9;
            4'd9: next_count = 4'd0;
            default: next_count = 4'd0;
        endcase
    end
endfunction

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_count(q);
end

endmodule