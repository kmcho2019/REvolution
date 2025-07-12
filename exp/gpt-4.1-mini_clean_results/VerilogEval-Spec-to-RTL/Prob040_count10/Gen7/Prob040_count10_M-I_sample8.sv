module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else begin
        // Increment q, wrap to 0 after 9
        // Use addition and conditional subtraction for modulo 10
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
    end
end

endmodule