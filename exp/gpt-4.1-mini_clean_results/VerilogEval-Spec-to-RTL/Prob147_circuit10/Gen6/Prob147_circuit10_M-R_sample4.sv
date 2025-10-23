module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Combinational block to determine next_state based on inputs and current state
always @(*) begin
    case ({b,a})
        2'b11: next_state = ~state; // b=1, a=1 toggle state
        2'b10: next_state = 1'b1;   // b=1, a=0 set state
        default: next_state = 1'b0; // otherwise reset state
    endcase
end

// Sequential block to update state at posedge clk
always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0; // Initialize state for simulation
end

endmodule