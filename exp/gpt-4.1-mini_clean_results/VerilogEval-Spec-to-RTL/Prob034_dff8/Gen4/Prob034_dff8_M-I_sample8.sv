module TopModule (
    input clk,
    input reset_n,     // Active low asynchronous reset
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule