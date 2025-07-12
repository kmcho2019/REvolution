module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    integer i;
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else
            for (i = 0; i < 8; i = i + 1)
                q[i] <= d[i];
    end
endmodule