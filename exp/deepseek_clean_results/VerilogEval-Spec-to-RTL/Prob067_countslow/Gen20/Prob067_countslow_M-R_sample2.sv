module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Reset to 0
    end else if (slowena) begin
        // Increment with wrap-around from 9 to 0
        q <= (q == 4'b1001) ? 4'b0000 : q + 1;
    end
    // Else maintain current value (implicit)
end

endmodule