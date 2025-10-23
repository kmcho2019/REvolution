module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
reg a_prev, b_prev;
wire inputs_changed = (a != a_prev) || (b != b_prev);
wire enable = inputs_changed;

always @(posedge clk) begin
    a_prev <= a;
    b_prev <= b;
    if (enable) begin
        state_reg <= (a & b) ? 1'b1 : 
                    ((~a & ~b) ? 1'b0 : 
                     state_reg);
    end
end

assign q = a ^ b ^ state_reg;
assign state = state_reg;

endmodule