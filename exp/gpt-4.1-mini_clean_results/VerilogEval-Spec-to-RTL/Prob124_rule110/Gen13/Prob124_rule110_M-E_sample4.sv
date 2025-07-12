module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Define left, center, right neighbor vectors with zero padding at boundaries
    wire [511:0] left   = {q[510:0], 1'b0};   // shift left by 1, zero on LSB
    wire [511:0] center = q;
    wire [511:0] right  = {1'b0, q[511:1]};   // shift right by 1, zero on MSB

    // Compute next state vector in parallel from the rule:
    // next = (~left & center) | (center ^ right)
    wire [511:0] next_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule