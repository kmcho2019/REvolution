module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        // Explicit shift register approach:
        // Shift right by one: Q[i] <= Q[i-1]
        // MSB gets inverse of current LSB.
        for (i = 63; i > 0; i = i - 1) begin
            Q[i] <= Q[i-1];
        end
        Q[0] <= ~Q[0];
    end
end

endmodule