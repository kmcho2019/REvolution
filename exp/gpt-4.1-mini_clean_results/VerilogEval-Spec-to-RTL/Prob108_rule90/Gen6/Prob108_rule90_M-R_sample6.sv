module TopModule (
    input          clk,
    input          load,
    input  [511:0] data,
    output reg [511:0] q
);

    wire [511:0] shifted_left  = {q[510:0], 1'b0};   // q shifted left by 1, LSB padded with 0
    wire [511:0] shifted_right = {1'b0, q[511:1]};   // q shifted right by 1, MSB padded with 0

    wire [511:0] next_state = shifted_left ^ shifted_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule