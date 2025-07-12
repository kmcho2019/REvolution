// Define the TopModule with the required ports
module TopModule #(
    parameter WIDTH = 8,
    parameter RESET_VALUE = 8'h34
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

// Single always_ff block with case statement to handle reset and data loading
always_ff @(negedge clk) begin
    case (1'b1)
        reset: q_reg <= RESET_VALUE;
        default: q_reg <= d;
    endcase
end

assign q = q_reg;

endmodule