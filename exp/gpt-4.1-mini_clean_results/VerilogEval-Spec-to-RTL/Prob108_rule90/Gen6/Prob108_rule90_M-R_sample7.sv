module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extend q with zero boundary bits on both sides to align neighbors
    wire [512:0] q_left = {q, 1'b0};    // q shifted left by 1, pad right with 0
    wire [512:0] q_right = {1'b0, q};   // q shifted right by 1, pad left with 0

    wire [511:0] next_state = q_left[511:0] ^ q_right[511:1];

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule