module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    case (state_reg)
        1'b0: begin
            if (~a && b) begin
                state_reg <= 1'b1;
            end
        end
        1'b1: begin
            if (a && b) begin
                state_reg <= 1'b0;
            end
        end
        default: state_reg <= 1'b0;
    endcase
end

assign q = (state_reg) || (a && ~b);
assign state = state_reg;

endmodule