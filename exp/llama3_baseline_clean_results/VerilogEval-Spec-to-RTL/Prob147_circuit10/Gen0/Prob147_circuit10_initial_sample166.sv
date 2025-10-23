module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @ (posedge clk) begin
    if (b) begin
        if (a) begin
            state_reg <= ~state_reg;
        end
    end else begin
        state_reg <= state_reg;
    end
end

assign q = (b) ? ~state : state;

endmodule