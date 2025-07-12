module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
reg q_reg;

always @(posedge clk) begin
    // State update logic
    if (a ^ b) begin
        state_reg <= ~state_reg;
    end
    
    // q output logic
    if (state_reg) begin
        q_reg <= b;
    end
    // else maintain q_reg value
end

assign q = q_reg;
assign state = state_reg;

endmodule