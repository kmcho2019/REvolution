module right_shifter (
    input  wire       clk,
    input  wire       rst_n,  // Active-low synchronous reset
    input  wire       d,
    output reg  [7:0] q
);

// Initialize q to zero for simulation
initial begin
    q = 8'b0;
end

always @(posedge clk) begin
    if (!rst_n)
        q <= 8'b0;
    else
        q <= {d, q[7:1]};
end

endmodule