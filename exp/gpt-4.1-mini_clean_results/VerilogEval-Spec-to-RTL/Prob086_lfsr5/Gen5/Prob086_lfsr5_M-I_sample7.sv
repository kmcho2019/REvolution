module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

function [4:0] next_lfsr;
    input [4:0] curr;
    reg fb;
begin
    fb = curr[0];
    // Shift right by 1 bit, with taps at q[4] and q[2] XORed with feedback
    next_lfsr = {fb, curr[4] ^ fb, curr[3], curr[2] ^ fb, curr[1]};
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Reset to 1
    end else begin
        q <= next_lfsr(q);
    end
end

endmodule