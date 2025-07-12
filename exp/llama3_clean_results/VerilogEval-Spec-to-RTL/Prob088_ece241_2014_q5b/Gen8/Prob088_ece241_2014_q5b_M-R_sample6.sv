module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg state; // One-hot encoding for state A

assign z = (state ^ x); // Combinational logic for z using assign

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Asynchronous reset to state A
        state <= 1'b0;
    end else begin
        // Transition from A to B when x=1, stay in B otherwise
        if(!state && x) begin
            state <= 1'b1; // Move to state B
        end else begin
            state <= state; // Stay in current state
        end
    end
end

endmodule