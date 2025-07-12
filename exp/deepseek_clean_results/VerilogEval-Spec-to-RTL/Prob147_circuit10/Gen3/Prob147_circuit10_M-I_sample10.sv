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
        2'b11: state_reg <= ~state_reg;  // Toggle when both inputs are 1
        2'b01: state_reg <= 1;           // Set to 1 when a=0 and b=1
        2'b10: state_reg <= 0;           // Reset to 0 when a=1 and b=0
        // default: retain state (for 2'b00 case)
    endcase
end

assign q = ~(state_reg ^ b);  // XNOR operation
assign state = state_reg;

endmodule