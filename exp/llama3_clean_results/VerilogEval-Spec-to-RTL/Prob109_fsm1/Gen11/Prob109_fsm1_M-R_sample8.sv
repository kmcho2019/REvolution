module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // current state (0 for A, 1 for B)
reg next_state; // next state

// Combinational logic for next state calculation
always @(*) begin
    case(state)
        1'b0: next_state = ~in;
        1'b1: next_state = in;
    endcase
end

// Sequential process to update the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        state <= next_state;
    end
end

// Assign output based on the current state
assign out = state;

endmodule