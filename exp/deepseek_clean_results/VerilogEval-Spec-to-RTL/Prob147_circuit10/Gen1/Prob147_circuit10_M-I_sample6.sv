module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;  // Initialize to 0 to match waveform

always @(posedge clk) begin
    case ({a,b})
        2'b00: state_reg <= 1'b1;  // Set state to 1 when a=0 and b=0
        2'b11: state_reg <= ~state_reg;  // Toggle state when a=1 and b=1
        default: state_reg <= state_reg;  // Maintain state otherwise
    endcase
end

assign q = a ? state_reg : (state_reg ^ b);
assign state = state_reg;

endmodule