module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b0; // Reset to state A
        z <= 1'b0;
    end else begin
        if(!state && x) begin // Transition from A to B
            state <= 1'b1;
            z <= 1'b1;
        end else if(state) begin // Stay in B
            z <= ~x;
        end else begin // Stay in A
            z <= 1'b0;
        end
    end
end

endmodule