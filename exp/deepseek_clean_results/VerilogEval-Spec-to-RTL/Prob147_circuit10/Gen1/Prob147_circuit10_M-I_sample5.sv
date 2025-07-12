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
        2'b00: state_reg <= (state_reg == 0) ? 1 : state_reg; // Set to 1 if currently 0
        2'b11: state_reg <= ~state_reg;                      // Toggle
        default: state_reg <= state_reg;                      // Retain state
    endcase
end

assign q = (state_reg ^ b);
assign state = state_reg;

endmodule