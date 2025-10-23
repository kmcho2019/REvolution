module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    reg [511:0] next_state;

    integer i;
    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // Left neighbor is q[i-1] except for i=0 (zero boundary)
            // Right neighbor is q[i+1] except for i=511 (zero boundary)
            wire left  = (i == 0)   ? 1'b0 : q[i-1];
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