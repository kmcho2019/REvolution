module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;               // synchronous reset to 0
    end else if (slowena) begin
        // increment with wrap-around at 9
        q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
    end
    // else: hold current q value, no unnecessary writes to q
end

endmodule