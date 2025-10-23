module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {S0, S1, S2} state, nextState;

// Combinational logic for next state
always_comb begin
    case (state)
        S0: nextState = x ? S1 : S0;
        S1: nextState = x ? S1 : S2;
        S2: nextState = x ? S1 : S0;
    endcase
end

// Sequential logic with asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= nextState;
    end
end

// Output logic
assign z = (state == S2) && x;

endmodule