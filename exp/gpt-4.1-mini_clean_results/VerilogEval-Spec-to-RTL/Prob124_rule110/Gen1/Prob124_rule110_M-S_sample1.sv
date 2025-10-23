module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left, right;
    wire [511:0] next_state;

    // Left neighbor bits: q shifted left by 1 with LSB=0 (boundary zero)
    assign left = {q[510:0], 1'b0};

    // Right neighbor bits: q shifted right by 1 with MSB=0 (boundary zero)
    assign right = {1'b0, q[511:1]};

    // Center is q itself
    // Rule 110 next state:
    // next = (~left & q) | (q ^ right) | (left & ~q & ~right);
    assign next_state = ((~left) & q) | (q ^ right) | (left & (~q) & (~right));

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule