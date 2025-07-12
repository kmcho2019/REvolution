module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg first_rising_edge = 1'b1;

always @(posedge clk) begin
    if (first_rising_edge && a) begin
        q <= 4;
        first_rising_edge <= 1'b0;
    end else if (!a) begin
        q <= (q + 1) % 8; // assuming 3-bit counter wraps around
    end
end

endmodule