module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg state; // 0 for state A, 1 for state B

always @(posedge clk or posedge areset) begin
    if(areset) begin
        // Reset to state A
        state <= 1'b0;
    end else begin
        // Transition to B if x=1 and currently in A, stay in B otherwise
        if(!state && x) begin
            state <= 1'b1;
        end
    end
end

// Combinational logic for output z
assign z = (state && ~x) || (!state && x);

endmodule