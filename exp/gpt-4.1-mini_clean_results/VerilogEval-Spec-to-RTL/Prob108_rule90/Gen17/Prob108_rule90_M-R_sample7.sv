module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // Compute next state combinationally
    wire [512:0] padded_left;  // q shifted right with zero prepended
    wire [512:0] padded_right; // q shifted left with zero appended
    wire [511:0] next_state;

    assign padded_left  = {1'b0, q[511:1]};   // left neighbor: q shifted right by 1, zero padded
    assign padded_right = {q[510:0], 1'b0};   // right neighbor: q shifted left by 1, zero padded

    assign next_state = padded_left ^ padded_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule