module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Shift q left and right with zero padding to represent neighbors
    wire [511:0] left_shifted  = {q[510:0], 1'b0};   // left neighbor (q[i+1], zero at MSB)
    wire [511:0] right_shifted = {1'b0, q[511:1]};   // right neighbor (q[i-1], zero at LSB)
    wire [511:0] center        = q;

    // Compute next state vector using Rule 110 formula:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_q = (~left_shifted & center) | (center ^ right_shifted);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule