module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    wire [511:0] left_shifted;
    wire [511:0] center;
    wire [511:0] right_shifted;
    wire [511:0] next_q;

    // Left neighbor: shift q left by 1, zero pad rightmost bit
    assign left_shifted  = {q[510:0], 1'b0};

    // Center is current q
    assign center        = q;

    // Right neighbor: shift q right by 1, zero pad leftmost bit
    assign right_shifted = {1'b0, q[511:1]};

    // Rule 110 next state for all bits in parallel
    // next = (~left & center) | (center ^ right)
    assign next_q = ((~left_shifted) & center) | (center ^ right_shifted);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule