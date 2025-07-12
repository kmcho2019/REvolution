module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    reg [511:0] next_state;
    integer i;

    always @* begin
        // Compute next_state combinationally, applying Rule 90 with zero boundaries
        for (i = 0; i < 512; i = i + 1) begin
            // left neighbor (0 for i==0)
            wire left = (i == 0) ? 1'b0 : q[i-1];
            // right neighbor (0 for i==511)
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