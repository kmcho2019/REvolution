module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    integer i;
    reg [511:0] next_state;

    always @* begin
        // Compute next_state based on Rule 90: next[i] = left_neighbor ^ right_neighbor
        // Boundaries (i = 0 and i = 511) neighbors outside array are 0
        for (i = 0; i < 512; i = i + 1) begin
            // left neighbor
            wire left = (i == 0) ? 1'b0 : q[i-1];
            // right neighbor
            wire right = (i == 511) ? 1'b0 : q[i+1];
            next_state[i] = left ^ right;
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule