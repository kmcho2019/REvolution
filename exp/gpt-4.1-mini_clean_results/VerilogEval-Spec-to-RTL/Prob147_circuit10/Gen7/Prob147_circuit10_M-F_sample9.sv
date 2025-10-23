module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Combinational logic for next_state considering current state and inputs a,b
always @(*) begin
    case ({a,b})
        2'b00: next_state = state;      // hold current state
        2'b01: next_state = 1'b1;       // set state to 1
        2'b10: next_state = 1'b0;       // set state to 0
        2'b11: next_state = ~state;     // toggle state
        default: next_state = state;    // default hold (should never occur)
    endcase
end

// Sequential update of state on positive edge of clock
always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0; // Initialize state to zero
end

endmodule