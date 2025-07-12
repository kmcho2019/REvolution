module right_shifter (
    input wire clk,
    input wire rst_n,  // synchronous active-low reset
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (!rst_n)
        q <= 8'b0;
    else begin
        q <= q >> 1;
        q[7] <= d;
    end
end

endmodule