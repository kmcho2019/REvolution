module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire clk_enable = j | k;  // Clock gating control

always @(posedge clk) begin
    if (clk_enable) begin
        if (j && k)
            Q <= ~Q;
        else if (j)
            Q <= 1'b1;
        else if (k)
            Q <= 1'b0;
    end
    // Implicit else: Q remains unchanged (clock gated)
end

endmodule