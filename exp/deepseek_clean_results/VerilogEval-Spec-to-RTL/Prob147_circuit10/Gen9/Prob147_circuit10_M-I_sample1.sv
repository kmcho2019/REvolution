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
        2'b00: state_reg <= 0;
        2'b11: state_reg <= 1;
        default: state_reg <= state_reg;  // maintain state
    endcase
end

assign q = (state_reg & (~a | ~b)) | (~state_reg & ~a & b);
assign state = state_reg;

endmodule