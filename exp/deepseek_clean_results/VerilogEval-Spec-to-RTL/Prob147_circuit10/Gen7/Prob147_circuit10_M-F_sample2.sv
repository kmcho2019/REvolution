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
        2'b11: state_reg <= ~state_reg;  // toggle when both are 1
        2'b10: state_reg <= 0;           // reset when a=1, b=0
        2'b01: state_reg <= 1;           // set when a=0, b=1
        default: state_reg <= state_reg; // hold otherwise
    endcase
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule