module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left  = {q[510:0], 1'b0};     // q shifted left by 1 with zero boundary at LSB
    wire [511:0] right = {1'b0, q[511:1]};     // q shifted right by 1 with zero boundary at MSB
    wire [511:0] center = q;

    wire [511:0] next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule