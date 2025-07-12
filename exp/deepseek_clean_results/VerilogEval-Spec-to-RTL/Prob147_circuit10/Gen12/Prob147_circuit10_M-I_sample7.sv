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
        2'b00: state_reg <= state_reg;  // Hold state
        2'b01: state_reg <= 0;          // Reset state
        2'b10: state_reg <= 1;          // Set state
        2'b11: state_reg <= ~state_reg; // Toggle state
    endcase
end

assign state = state_reg;
assign q = a ? state_reg : b;

endmodule