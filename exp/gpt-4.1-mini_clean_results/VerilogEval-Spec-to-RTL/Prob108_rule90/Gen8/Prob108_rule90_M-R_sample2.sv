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
            // Compute neighbors with zero boundary at edges
            // Left neighbor is q[i-1] if i>0 else 0
            // Right neighbor is q[i+1] if i<511 else 0
            next_state[i] = ((i == 0   ? 1'b0 : q[i-1]) ^ 
                             (i == 511 ? 1'b0 : q[i+1]));
        end
    end

    always @(posedge clk) begin
        if (load) q <= data;
        else      q <= next_state;
    end
endmodule