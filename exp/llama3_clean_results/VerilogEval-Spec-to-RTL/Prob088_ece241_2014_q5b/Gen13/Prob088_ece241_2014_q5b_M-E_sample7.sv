module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A (0) or State B (1)
reg toggle_clk; // Toggle clock signal

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        toggle_clk <= 1'b0; // Reset toggle clock
    end else if(x != state) begin
        state <= ~state; // Toggle state
        toggle_clk <= ~toggle_clk; // Toggle clock
    end
end

always @(*) begin
    if(state == 1'b0) begin
        z = x; // Output z in state A
    end else begin
        z = ~x; // Output z in state B
    end
end

endmodule