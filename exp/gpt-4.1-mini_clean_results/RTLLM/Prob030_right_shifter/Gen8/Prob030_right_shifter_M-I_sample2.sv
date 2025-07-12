module right_shifter (
    input wire clk,
    input wire rst_n,     // Active-low synchronous reset
    input wire en,        // Shift enable
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (!rst_n)
        q <= 8'b0;
    else if (en)
        q <= {d, q[7:1]};
    // else q remains unchanged (no shift)
end

endmodule