module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

function [4:0] next_lfsr;
    input [4:0] curr;
    reg feedback;
begin
    // feedback is the outgoing bit q[0]
    feedback = curr[0];
    // Shift right by one bit
    next_lfsr[0] = curr[1];
    next_lfsr[1] = curr[2];
    // Tap at bit 3 (q[2]) XOR feedback
    next_lfsr[2] = curr[3] ^ feedback;
    next_lfsr[3] = curr[4];
    // Tap at bit 5 (q[4]) gets feedback directly
    next_lfsr[4] = feedback;
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Initialize to 1 on reset
    end else begin
        q <= next_lfsr(q);
    end
end

endmodule