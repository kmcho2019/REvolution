module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    wire [513:0] ext_q = {1'b0, q, 1'b0};
    reg  [511:0] next_state;

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Neighbors
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110: next = (~left & center) | (center ^ right)
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