module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    wire enable = slowena && !reset;

    always @(posedge clk) begin
        if (reset)
            q <= 0;
        else if (enable)
            q <= (q == 9) ? 0 : q + 1;
    end

endmodule