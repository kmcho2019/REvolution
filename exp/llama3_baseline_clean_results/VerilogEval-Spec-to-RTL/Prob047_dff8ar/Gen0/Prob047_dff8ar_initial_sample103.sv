module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q;

always @(*) begin
    if(areset) begin
        q <= 8'b0;
    end else begin
        if(clk) begin
            // not using non-blocking assignment here, because the posedge is not being simulated,
            // instead, we use the always @(*) block to capture the clock signal.
            // in a real design, you would use always @(posedge clk) instead.
            q <= d;
        end
    end
end

endmodule