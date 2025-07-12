module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 4'd0;
    end else if (slowena) begin
        if (state_reg == 4'd9) begin
            state_reg <= 4'd0;
        end else begin
            state_reg <= state_reg + 4'd1;
        end
    end
end

assign q = state_reg;

endmodule