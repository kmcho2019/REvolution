module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;  // State flip-flop
reg q_reg = 1'b0;      // Output flip-flop for holding q value

always @(posedge clk) begin
    // State transition logic
    if (a & b) begin
        state_reg <= ~state_reg;
    end
    
    // Output logic
    if (a & ~b) begin
        // Hold q value when a=1 and b=0
        q_reg <= q_reg;
    end else begin
        // Normal operation: q = state ? ~b : b
        q_reg <= state_reg ? ~b : b;
    end
end

assign q = q_reg;
assign state = state_reg;

endmodule