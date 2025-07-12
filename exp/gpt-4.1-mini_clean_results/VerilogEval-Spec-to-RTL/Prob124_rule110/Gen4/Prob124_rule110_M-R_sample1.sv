module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state from current state with zero boundaries
    function [511:0] compute_next_state;
        input [511:0] state;
        integer idx;
        reg left, center, right;
        reg [513:0] padded_state;
    begin
        padded_state = {1'b0, state, 1'b0};  // zero boundary padding
        for (idx = 0; idx < 512; idx = idx + 1) begin
            left = padded_state[idx + 2];
            center = padded_state[idx + 1];
            right = padded_state[idx];
            compute_next_state[idx] = (~left & center) | (center ^ right);
        end
    end
    endfunction

    wire [511:0] next_state = compute_next_state(q);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule