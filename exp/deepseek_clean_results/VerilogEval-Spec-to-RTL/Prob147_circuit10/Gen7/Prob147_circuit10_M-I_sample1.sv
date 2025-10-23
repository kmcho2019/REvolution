module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;  // Initialize to 0

always @(posedge clk) begin
    case ({a,b})
        2'b00: state_reg <= 1'b1;  // Set to 1 when both inputs are 0
        2'b11: state_reg <= ~state_reg;  // Toggle when both inputs are 1
        default: state_reg <= state_reg;  // Maintain state otherwise
    endcase
end

assign q = state_reg ^ b;  // XOR matches the required q behavior
assign state = state_reg;

endmodule