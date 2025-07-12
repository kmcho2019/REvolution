module right_shifter (
    input wire clk,
    input wire reset,    // synchronous active-high reset
    input wire enable,   // shift enable
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else if (enable) begin
        q <= {d, q[7:1]};
    end
    // else retain previous q (no shift)
end

endmodule