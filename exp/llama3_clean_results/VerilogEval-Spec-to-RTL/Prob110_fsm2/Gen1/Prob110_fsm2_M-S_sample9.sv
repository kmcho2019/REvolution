module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// State register with asynchronous reset
reg state;
always_ff @(posedge clk or posedge areset) begin
    if(areset) state <= 1'b0; // OFF state
    else begin
        case({j, k})
            2'b01: state <= 1'b1; // Transition from OFF to ON when j=1
            2'b11: state <= 1'b0; // Transition from ON to OFF when k=1
            default: state <= state; // Stay in current state for other combinations
        endcase
    end
end

// Output logic
assign out = state;

endmodule