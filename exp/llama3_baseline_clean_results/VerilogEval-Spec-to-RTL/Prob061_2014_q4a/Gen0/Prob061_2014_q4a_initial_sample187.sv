module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg q_reg;  // Register to store the state
assign Q = q_reg;  // Output is the current state

always @(posedge clk) begin
    if (L) begin
        // Load R into the register
        q_reg <= R;
    end else if (E) begin
        // Shift w into the register
        q_reg <= w;
    end
end

endmodule