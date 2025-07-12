module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extend current state with zero boundaries for neighbor access
    wire [513:0] padded_q;

    assign padded_q = {1'b0, q, 1'b0};

    // Combinational function to compute the next state of all cells
    function [511:0] compute_next;
        input [513:0] current_state;
        integer idx;
        reg left, center, right;
        begin
            for (idx = 0; idx < 512; idx = idx + 1) begin
                left   = current_state[idx + 2];
                center = current_state[idx + 1];
                right  = current_state[idx];
                // Rule 110 next state formula
                compute_next[idx] = (~left & center) | (center ^ right);
            end
        end
    endfunction

    // Sequential logic to load or update state at clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= compute_next(padded_q);
        end
    end

endmodule