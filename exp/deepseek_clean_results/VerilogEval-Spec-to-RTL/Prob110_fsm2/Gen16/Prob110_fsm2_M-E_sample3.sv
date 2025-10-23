module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state_OFF, state_ON;  // One-hot states

// Next state logic
wire next_OFF = (state_OFF & ~j) | (state_ON & k);
wire next_ON  = (state_OFF & j) | (state_ON & ~k);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_OFF <= 1'b1;
        state_ON  <= 1'b0;
    end
    else begin
        state_OFF <= next_OFF;
        state_ON  <= next_ON;
    end
end

assign out = state_ON;  // Output is directly the ON state

endmodule