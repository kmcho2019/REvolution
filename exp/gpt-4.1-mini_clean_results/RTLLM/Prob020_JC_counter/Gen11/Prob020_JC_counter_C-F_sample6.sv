module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        // Next state: MSB gets inverse of current LSB; all other bits shift right by one
        // Equivalent to:
        // Q[63] <= ~Q[0];
        // Q[i] <= Q[i+1]; for i = 62 down to 0
        Q <= {~Q[0], Q[63:1]};
end

endmodule