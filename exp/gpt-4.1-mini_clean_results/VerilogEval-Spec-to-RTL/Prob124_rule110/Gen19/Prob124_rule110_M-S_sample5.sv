module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 512; i = i + 1) begin
                // Determine neighbors with zero boundaries
                // left = q[i+1] if i < 511 else 0
                // center = q[i]
                // right = q[i-1] if i > 0 else 0
                reg left, center, right;
                left   = (i < 511) ? q[i+1] : 1'b0;
                center = q[i];
                right  = (i > 0)   ? q[i-1] : 1'b0;

                // Apply Rule 110: next = (~left & center) | (center ^ right)
                next_state[i] = (~left & center) | (center ^ right);
            end
            q <= next_state;
        end
    end

endmodule