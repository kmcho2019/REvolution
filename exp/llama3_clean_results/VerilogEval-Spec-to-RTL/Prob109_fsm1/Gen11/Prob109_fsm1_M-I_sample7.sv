module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // current state (0 for A, 1 for B)

// Sequential process to update the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        if (state == 1'b0) begin
            if (in) begin
                state <= 1'b0; // stay in state A
            end else begin
                state <= 1'b1; // move to state B
            end
        end else begin
            if (in) begin
                state <= 1'b1; // stay in state B
            end else begin
                state <= 1'b0; // move to state A
            end
        end
    end
end

// Assign output based on the current state
assign out = state;

endmodule