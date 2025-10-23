module right_shifter (
    input wire clk,
    input wire en,      // Enable signal for power optimization
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (en) begin
        q <= {d, q[7:1]};
    end
end

endmodule