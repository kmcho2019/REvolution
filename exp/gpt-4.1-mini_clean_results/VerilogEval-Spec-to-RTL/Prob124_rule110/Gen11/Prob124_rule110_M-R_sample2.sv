module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state;
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Boundary neighbors: zero if out of range
            // Left = q[i+1] unless at rightmost cell (i=511)
            // Right = q[i-1] unless at leftmost cell (i=0)
            wire left   = (i < 511) ? q[i + 1] : 1'b0;
            wire center = q[i];
            wire right  = (i > 0)   ? q[i - 1] : 1'b0;

            // Rule 110 next state:
            // next = (~left & center) | (center ^ right)
            next_state[i] = (~left & center) | (center ^ right);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule