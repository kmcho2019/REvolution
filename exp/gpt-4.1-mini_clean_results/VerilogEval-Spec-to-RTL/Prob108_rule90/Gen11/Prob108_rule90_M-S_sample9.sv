module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_shift;
    wire [511:0] right_shift;
    wire [511:0] next_state;

    // Boundary conditions: bits outside q are zero
    // left neighbor: q shifted right by 1, with 0 inserted at MSB
    assign left_shift = {q[510:0], 1'b0};
    // right neighbor: q shifted left by 1, with 0 inserted at LSB
    assign right_shift = {1'b0, q[511:1]};
    // next state is XOR of neighbors
    assign next_state = left_shift ^ right_shift;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule