module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left  = {q[510:0], 1'b0};  // q shifted left with zero at LSB
    wire [511:0] right = {1'b0, q[511:1]};  // q shifted right with zero at MSB
    wire [511:0] next_state = (~left & q) | (q ^ right); // Rule 110 next state

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule