module TopModule(
    input         clk,
    input         areset,
    input         x,
    output        z
);

reg stateA;
reg stateB;

// Combinational logic to determine next state
wire nextStateA;
wire nextStateB;

// Combinational logic to determine output z
assign z = (stateA && ~x) || (stateB && x);

// Determine next state
assign nextStateA = (~areset && stateA && ~x) || (areset && 1'b1);
assign nextStateB = (~areset && (stateA && x || stateB)) || (areset && 1'b0);

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        stateA <= 1'b1;
        stateB <= 1'b0;
    end else begin
        stateA <= nextStateA;
        stateB <= nextStateB;
    end
end

endmodule