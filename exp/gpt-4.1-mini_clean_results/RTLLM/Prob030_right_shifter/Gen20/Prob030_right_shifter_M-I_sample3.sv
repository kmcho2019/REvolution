module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

// Initial block for simulation only
initial q = 8'b0;

wire [7:0] shifted_q = {d, q[7:1]};
wire shift_needed = (shifted_q != q);

always @(posedge clk) begin
    if (shift_needed)
        q <= shifted_q;
    else
        q <= q; // Hold to reduce toggling (optional, could omit)
end

endmodule