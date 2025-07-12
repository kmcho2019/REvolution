module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0] q
);
    // Negative edge triggered 8-bit register with synchronous active-high reset to 0x34
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;
        else
            q <= d;
    end
endmodule