module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // Pad the left and right neighbors by shifting with zero padding at boundaries
    wire [511:0] left_cells  = {q[510:0], 1'b0}; // shift left, rightmost boundary zero
    wire [511:0] center_cells = q;
    wire [511:0] right_cells = {1'b0, q[511:1]}; // shift right, leftmost boundary zero

    /*
    Rule 110 truth table for the next state:
    Left Center Right | Next
       1     1     1  | 0
       1     1     0  | 1
       1     0     1  | 1
       1     0     0  | 0
       0     1     1  | 1
       0     1     0  | 1
       0     0     1  | 1
       0     0     0  | 0

    The next state is 1 except in cases 111, 100, 000.
    Let's write the Boolean expression for next state (N):

    N = (~L & C) | (C & ~R) | (L & ~C & R)
    or simplified as:
    N = (C & (~R | ~L)) | (L & ~C & R)
    */

    wire [511:0] next_q;
    assign next_q = (center_cells & (~right_cells | ~left_cells)) | (left_cells & ~center_cells & right_cells);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end
endmodule