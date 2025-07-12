module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a & b) begin  // Toggle state when both inputs are high
        state_reg <= ~state_reg;
    end
end

assign q = (a & (state_reg == b)) | (~a & b);
assign state = state_reg;

endmodule