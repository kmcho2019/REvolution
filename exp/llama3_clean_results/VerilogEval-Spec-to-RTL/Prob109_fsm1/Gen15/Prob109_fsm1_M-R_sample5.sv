module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // 1 represents state B, 0 represents state A
reg next_state; // Next state based on current state and input

// Combinational logic to compute next state
assign next_state = (state == 1'b0)? (in? 1'b0 : 1'b1) : (in? 1'b1 : 1'b0);

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        state <= next_state;
    end
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule