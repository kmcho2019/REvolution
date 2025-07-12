module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

assign z = (state) ? ~x : x; // Directly assign output z based on state and input x

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
    end else begin
        if(!state && x) begin // Transition from A to B
            state <= 1'b1;
        end else if(state || (!state && !x)) begin // Stay in current state (either A or B)
            state <= state; // No change
        end
    end
end

endmodule