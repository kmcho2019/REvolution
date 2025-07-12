module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Toggle q when a is 1
    end else begin
        // Do nothing when a is 0, maintaining the current state of q
    end
end

endmodule