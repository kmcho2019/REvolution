module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    always @(negedge clk) begin
        if (reset)
            q <= 8'h34; // synchronous active-high reset loads 0x34
        else
            q <= d;
    end
endmodule