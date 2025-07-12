module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Reset to 0
    end
    else if (slowena) begin
        if (q == 4'b1001)  // Direct comparison for 9
            q <= 4'b0000;
        else
            q <= q + 4'b0001;
    end
end

endmodule