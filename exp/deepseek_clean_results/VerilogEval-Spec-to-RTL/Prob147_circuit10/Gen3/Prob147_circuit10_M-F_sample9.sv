module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    case ({a,b})
        2'b00: state_reg <= 1'b1;  // Set state to 1 when a=0 and b=0
        2'b11: state_reg <= ~state_reg;  // Toggle when both a and b are 1
        default: state_reg <= state_reg;  // Hold state otherwise
    endcase
end

assign q = b ^ state_reg;  // XOR operation
assign state = state_reg;

endmodule