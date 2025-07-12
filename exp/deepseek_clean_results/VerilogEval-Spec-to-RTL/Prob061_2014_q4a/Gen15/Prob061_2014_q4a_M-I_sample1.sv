module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

wire gated_clk;
wire hold_mode = ~(E | L);  // Hold when both E and L are low
assign gated_clk = hold_mode ? 1'b0 : clk;

always @(posedge gated_clk) begin
    if (L)
        Q <= R;
    else if (E)
        Q <= w;
    // No else needed - clock is gated in hold mode
end

endmodule