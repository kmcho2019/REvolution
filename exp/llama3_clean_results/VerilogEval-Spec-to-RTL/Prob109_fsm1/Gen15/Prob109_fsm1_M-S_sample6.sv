module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // 1 represents state B, 0 represents state A

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        state <= (state == 1'b1) ? in : !in; // Simplified state transition logic
    end
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule