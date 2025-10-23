module right_shifter (
    input  wire       clk,
    input  wire       rst_n,   // Active-low synchronous reset
    input  wire       d,
    output reg  [7:0] q
);

localparam [7:0] INIT_VALUE = 8'b0;

always @(posedge clk) begin
    if (~rst_n)
        q <= INIT_VALUE;
    else
        q <= {d, q[7:1]};
end

endmodule