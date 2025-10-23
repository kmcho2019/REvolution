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
            // left neighbor; zero if i is last cell
            wire left = (i == 511) ? 1'b0 : q[i+1];
            // center
            wire center = q[i];
            // right neighbor; zero if i is first cell
            wire right = (i == 0) ? 1'b0 : q[i-1];

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