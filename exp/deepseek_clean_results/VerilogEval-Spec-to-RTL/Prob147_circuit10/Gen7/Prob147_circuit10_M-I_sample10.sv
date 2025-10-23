module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    case ({a,b})
        2'b00: state_reg <= state_reg;  // Hold state
        2'b01: state_reg <= 1'b1;      // Set state to 1
        2'b10: state_reg <= 1'b0;      // Set state to 0
        2'b11: state_reg <= ~state_reg; // Toggle state
    endcase
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule