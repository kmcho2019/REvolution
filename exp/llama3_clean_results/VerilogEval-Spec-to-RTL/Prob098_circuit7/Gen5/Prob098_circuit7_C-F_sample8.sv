module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 1'b0) begin
        q <= 1'b1; // Explicitly assign 1 when a is 0
    end else if (q == 1'b1) begin
        q <= 1'b0; // Transition to 0 only after q has been 1
    end
end

endmodule