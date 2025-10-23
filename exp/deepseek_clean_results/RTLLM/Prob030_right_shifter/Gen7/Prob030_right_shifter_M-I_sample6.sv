module right_shifter #(
    parameter WIDTH = 8
) (
    input clk,
    input d,
    input en,        // Enable signal for power gating
    output reg [WIDTH-1:0] q = 0
);

reg [WIDTH-1:0] q_next;

always @(posedge clk) begin
    if (en) begin
        q <= q_next;
    end
    // Else retain value (implicit)
end

always @(*) begin
    q_next = {d, q[WIDTH-1:1]};
end

endmodule