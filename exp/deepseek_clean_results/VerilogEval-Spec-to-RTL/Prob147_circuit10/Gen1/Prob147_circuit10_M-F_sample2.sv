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
        2'b00: state_reg <= 1;  // Set state to 1 when a=0 and b=0
        2'b11: state_reg <= ~state_reg;  // Toggle state when a=1 and b=1
        default: state_reg <= state_reg;  // Retain state otherwise
    endcase
end

assign q = a ? (b ? ~state_reg : state_reg) : b;
assign state = state_reg;

endmodule