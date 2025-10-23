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
            // Define neighbors, treating out-of-bounds as 0
            // left neighbor: q[i+1] if i < 511 else 0
            // right neighbor: q[i-1] if i > 0 else 0
            // center: q[i]
            wire left = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right = (i > 0) ? q[i-1] : 1'b0;

            // Rule 110 next state
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