module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    reg [511:0] state;

    // Function to compute next state of all 512 cells for Rule 90
    function [511:0] compute_next;
        input [511:0] curr;
        integer j;
        reg left, right;
        begin
            for (j = 0; j < 512; j = j + 1) begin
                left  = (j == 0)   ? 1'b0 : curr[j-1];
                right = (j == 511) ? 1'b0 : curr[j+1];
                compute_next[j] = left ^ right;
            end
        end
    endfunction

    // Output is current state
    assign q = state;

    // Sequential logic to update state on clock edge
    always @(posedge clk) begin
        if (load)
            state <= data;
        else
            state <= compute_next(state);
    end
endmodule