module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left  = {q[510:0], 1'b0};
    wire [511:0] right = {1'b0, q[511:1]};
    wire [511:0] next_state = (~left & q) | (q ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule