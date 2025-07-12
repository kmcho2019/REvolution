module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  d,
    output reg [7:0] q
);
    // Negative edge triggered synchronous reset register with preset 8'h34
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34;
        else
            q <= d;
    end
endmodule