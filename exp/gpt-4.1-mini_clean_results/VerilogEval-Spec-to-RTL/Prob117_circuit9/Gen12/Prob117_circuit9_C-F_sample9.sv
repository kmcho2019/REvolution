module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Function to compute next state based on current q and input a
function [2:0] next_state;
    input [2:0] curr_q;
    input       a_in;
    reg [3:0] temp; // 4 bits to hold intermediate value for modulo arithmetic
    begin
        if (a_in) begin
            // When a is 1, always set state to 4
            next_state = 3'd4;
        end else begin
            // When a is 0, increment state modulo 7 with custom sequence
            // The valid states are 0 to 6, counting circularly
            // Sequence: 4->5->6->0->1->2->3->4...
            // So we treat states 0-6 as modulo 7 numbers.
            temp = (curr_q == 3'd6) ? 3'd0 : curr_q + 1; // Wrap at 6->0
            next_state = temp[2:0];
        end
    end
endfunction

wire [2:0] next_q = next_state(q, a);

always @(posedge clk) begin
    if (q !== next_q)
        q <= next_q;
    // else do not update q to reduce switching power
end

endmodule