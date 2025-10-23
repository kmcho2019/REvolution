module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else if (q[0])
            q <= (q >> 1) ^ (1 << 31) ^ (1 << 21) ^ (1 << 1) ^ 1;
        else
            q <= q >> 1;
    end

endmodule