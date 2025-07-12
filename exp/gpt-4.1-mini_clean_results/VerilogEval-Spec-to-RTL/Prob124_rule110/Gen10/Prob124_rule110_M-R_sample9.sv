module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Define neighbors with zero boundary conditions
            // left = q[i+1] if i != 511 else 0
            // center = q[i]
            // right = q[i-1] if i != 0 else 0
            // Rule 110 next state: (~left & center) | (center ^ right)
            reg left, center, right;
            left = (i == 511) ? 1'b0 : q[i+1];
            center = q[i];
            right = (i == 0) ? 1'b0 : q[i-1];
            next_q[i] = (~left & center) | (center ^ right);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule