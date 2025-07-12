module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q;  // Toggle q on the rising edge of clk when a is 1
    end else begin
        // Do nothing, keep the current state
    end
end

endmodule