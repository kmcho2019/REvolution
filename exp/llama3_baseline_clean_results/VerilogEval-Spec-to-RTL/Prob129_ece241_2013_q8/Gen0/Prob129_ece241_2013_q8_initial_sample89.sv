module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// State definition
enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10
} state, next_state;

// Combinational logic for next state
always_comb begin
    case (state)
        S0: next_state = (x == 1'b1) ? S1 : S0;
        S1: next_state = (x == 1'b0) ? S2 : S1;
        S2: next_state = (x == 1'b1) ? S1 : S2;
        default: next_state = S0;
    endcase
end

// Sequential logic for state update
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for output z
assign z = (state == S2) && (x == 1'b1);

endmodule