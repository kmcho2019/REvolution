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
        if (state == 1'b0) begin // Currently in state A
            state <= in ? 1'b0 : 1'b1; // Stay in A if in=1, move to B if in=0
        end else begin // Currently in state B
            state <= in ? 1'b1 : 1'b0; // Stay in B if in=1, move to A if in=0
        end
    end
end

// Assign output based on the current state
assign out = state;

endmodule