module right_shifter #
(
    parameter WIDTH = 8
)
(
    input clk,  // Clock signal
    input rst_n,  // Active low reset signal
    input en,    // Enable signal for the shift operation
    input d,    // Input signal to be right-shifted
    output [WIDTH-1:0] q  // Output signal representing the result of the right shift operation
);

reg [WIDTH-1:0] q_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q_reg <= '0;
    end else if (en) begin
        q_reg <= {d, q_reg[WIDTH-1:1]};
    end
end

assign q = q_reg;

endmodule