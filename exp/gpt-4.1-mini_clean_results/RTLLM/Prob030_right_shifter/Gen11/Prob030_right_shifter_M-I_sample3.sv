module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;
end

// Generate enable signal internally to reduce switching when input d does not change or does not affect MSB
wire shift_enable = (d != q[7]);

always @(posedge clk) begin
    // Synthesis directive to infer shift register primitive
    (* shreg_extract = "yes" *)
    if (shift_enable)
        q <= {d, q[7:1]};
    else
        q <= q; // hold value to avoid toggling
end

endmodule