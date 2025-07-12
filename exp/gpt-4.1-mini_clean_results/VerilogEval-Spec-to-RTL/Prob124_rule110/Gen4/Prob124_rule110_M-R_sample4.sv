module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute the next state of a cell with boundary handling
    function automatic logic next_cell_state(
        input logic left,
        input logic center,
        input logic right
    );
        // Apply Rule 110:
        // next = (~left & center) | (center ^ right);
        next_cell_state = (~left & center) | (center ^ right);
    endfunction

    wire [511:0] next_state;
    integer i;

    // Combinational block to compute all next states
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Handle boundaries with zero-padding
            logic left  = (i == 511) ? 1'b0 : q[i + 1];
            logic center = q[i];
            logic right = (i == 0) ? 1'b0 : q[i - 1];
            next_state[i] = next_cell_state(left, center, right);
        end
    end

    // Synchronous state update and loading
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule