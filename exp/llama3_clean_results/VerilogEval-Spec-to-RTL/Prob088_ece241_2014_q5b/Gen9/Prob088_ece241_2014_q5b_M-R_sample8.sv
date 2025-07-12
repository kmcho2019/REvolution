module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // State A is represented by 0, State B by 1

assign z = (state ^ x); // Combinational logic for output z

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A (0)
        state <= 1'b0;
    end else begin
        // State transition logic
        if(~state && x) begin
            // Transition from A to B if x=1
            state <= 1'b1;
        end else begin
            // Stay in the current state otherwise
            state <= state;
        end
    end
end

endmodule