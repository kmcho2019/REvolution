module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Function to compute next state based on current q and a
function [2:0] calc_next;
    input [2:0] curr_q;
    input a_in;
    reg [3:0] incremented; // 4 bits to handle overflow before modulo
    begin
        if (a_in) begin
            calc_next = 3'd4; // Hold q=4 when a=1
        end else begin
            // increment modulo 7, cycling through 4..6,0..3 in sequence
            incremented = curr_q + 1;
            // modulo 7 operation:
            // states cycle: 4->5->6->0->1->2->3->4...
            // valid states 0..6, so modulo 7 wraps at 7.
            if (incremented == 7)
                incremented = 0;
            calc_next = incremented[2:0];
        end
    end
endfunction

reg [2:0] next_q;

always @(*) begin
    next_q = calc_next(q, a);
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule