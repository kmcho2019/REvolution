module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {S0, S1, S2} state, next_state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// State transitions
always @(*) begin
    case (state)
        S0: next_state = x ? S1 : S0;
        S1: next_state = !x ? S2 : S1;
        S2: next_state = x ? S1 : S0;
    endcase
end

// Output logic
assign z = (state == S2) && x;

endmodule