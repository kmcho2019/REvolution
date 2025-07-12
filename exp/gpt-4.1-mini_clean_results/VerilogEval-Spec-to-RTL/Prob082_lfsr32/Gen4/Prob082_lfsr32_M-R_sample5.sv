module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for positions 32, 22, 2, and 1 (0-based indexing: 31, 21, 1, 0)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    // Function to compute next LFSR state based on current q
    function [31:0] next_lfsr_state;
        input [31:0] current;
        reg feedback_bit;
        begin
            feedback_bit = current[0];
            if (feedback_bit)
                next_lfsr_state = (current >> 1) ^ TAP_MASK;
            else
                next_lfsr_state = current >> 1;
        end
    endfunction

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_lfsr_state(q);
    end

endmodule