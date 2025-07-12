module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg gated_clock;
wire active_clock = gated_clock & clk;

always @(posedge clk) begin
    gated_clock <= ~(q == 4'd9);  // Gate clock when counter reaches 9
end

always @(posedge active_clock or posedge reset) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        if (q == 4'd9) begin      // Direct comparison for better timing
            q <= 4'b0000;
        end
        else begin
            q <= q + 1'b1;        // Simple increment operation
        end
    end
end

endmodule