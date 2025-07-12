module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // next_state is combinationally generated each cycle
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;

    // For left neighbors: shift q left by 1, leftmost neighbor is zero
    assign left_shifted = {q[510:0], 1'b0};
    // For right neighbors: shift q right by 1, rightmost neighbor is zero
    assign right_shifted = {1'b0, q[511:1]};

    wire [511:0] next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule