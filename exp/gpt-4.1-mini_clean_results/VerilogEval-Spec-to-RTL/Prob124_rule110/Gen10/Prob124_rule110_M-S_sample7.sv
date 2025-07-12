module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Get neighbors with zero boundary assumptions
            // left = q[i+1] if i < 511 else 0
            // center = q[i]
            // right = q[i-1] if i > 0 else 0
            wire left = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right = (i > 0) ? q[i-1] : 1'b0;

            // Apply Rule 110: next = (~left & center) | (center ^ right)
            next_state[i] = (~left & center) | (center ^ right);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule