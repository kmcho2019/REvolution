module right_shifter (
    input  wire       clk,
    input  wire       rst,   // synchronous active-high reset added for proper init
    input  wire       d,
    output reg  [7:0] q
);

// Synchronous reset for consistent initialization across simulators and synthesis
always @(posedge clk) begin
    if (rst) begin
        q <= 8'b0;
    end else if (d != q[7]) begin
        // Shift only if new input bit differs from current MSB to reduce toggling
        q <= {d, q[7:1]};
    end
    // else retain current q to save toggling power
end

endmodule