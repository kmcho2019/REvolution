module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg state;

// Output logic
assign out = state;

// State register with asynchronous reset and transition logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= 0;
    else begin
        case({j, k})
            2'b01: state <= 1; // Transition to ON when j=1
            2'b10: state <= 0; // Transition to OFF when k=1
            default: state <= state; // Stay in current state for other input combinations
        endcase
    end
end

endmodule