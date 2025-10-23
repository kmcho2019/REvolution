module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states
enum logic [1:0] {S0, S1, S2} state, next_state;

// Asynchronous reset and state transition logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= S0;
    end else begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = ~x ? S2 : S1;
            S2: next_state = x ? S1 : S0;
        endcase
        state <= next_state;
    end
end

// Output logic
assign z = (state == S2) && x;

endmodule