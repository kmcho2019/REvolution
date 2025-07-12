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
        if(state == 1'b0) begin
            state <= ~in; // From A, move to B on 0, stay in A on 1
        end else begin
            state <= in;  // From B, move to A on 0, stay in B on 1
        end
    end
end

// Assign output based on the current state
assign out = state;

endmodule