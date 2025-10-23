module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left, right;
    wire [511:0] next_state;

    // Left neighbor bits: shift q left by 1, pad LSB with 0 (boundary zero)
    assign left = {q[510:0], 1'b0};

    // Right neighbor bits: shift q right by 1, pad MSB with 0 (boundary zero)
    assign right = {1'b0, q[511:1]};

    // Apply corrected Rule 110 boolean logic
    assign next_state = (left & q & ~right) |
                        (left & ~q & right) |
                        (~left & q) |
                        (~left & ~q & right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule