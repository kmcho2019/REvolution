module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;
reg q_reg = 1'b0;

always @(posedge clk) begin
    // State toggles only when both a and b are high
    if (a & b) begin
        state_reg <= ~state_reg;
    end
end

always @(*) begin
    // Case 1: When state is 1 and b is 1
    if (state_reg & b) begin
        q_reg = 1'b1;
    end
    // Case 2: When a is 1 and b is 0 and previous q was 1
    else if (a & ~b & q_reg) begin
        q_reg = 1'b1;
    end
    // Case 3: When a is 0 and b is 0 and state is 1
    else if (~a & ~b & state_reg) begin
        q_reg = 1'b1;
    end
    else begin
        q_reg = 1'b0;
    end
end

assign q = q_reg;
assign state = state_reg;

endmodule