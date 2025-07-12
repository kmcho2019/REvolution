module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

// Define the reset value as a constant
localparam RESET_VALUE = 8'h34;

always @(negedge clk) begin
    if(reset) begin
        // Use the defined constant for reset
        q_reg <= RESET_VALUE;
    end else begin
        q_reg <= d;
    end
end

// Directly assign q_reg to q
assign q = q_reg;

endmodule