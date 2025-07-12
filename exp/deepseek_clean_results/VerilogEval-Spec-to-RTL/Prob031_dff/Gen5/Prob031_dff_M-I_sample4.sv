module TopModule (
    input clk,
    input d,
    input reset_n,  // asynchronous active-low reset
    output reg q
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        q <= 1'b0;  // reset state
    else
        q <= d;     // normal operation
end

endmodule