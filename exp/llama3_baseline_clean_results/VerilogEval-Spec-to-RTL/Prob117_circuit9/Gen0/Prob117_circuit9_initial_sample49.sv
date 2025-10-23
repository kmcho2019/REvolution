module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4; // hold q at 4 when a is high
    end else begin
        q <= (q == 7) ? 0 : q + 1; // increment q when a is low, wrapping around at 7
    end
end

endmodule