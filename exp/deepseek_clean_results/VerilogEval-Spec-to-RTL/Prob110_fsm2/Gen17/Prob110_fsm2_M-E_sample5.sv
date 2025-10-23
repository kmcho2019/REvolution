module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// One-hot state encoding
reg state_OFF, state_ON;

// Next state wires
wire next_OFF, next_ON;

// State transition logic
assign next_OFF = (state_OFF & ~j) | (state_ON & k);
assign next_ON  = (state_OFF & j) | (state_ON & ~k);

// State register
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

// Output assignment
assign out = state_ON;

endmodule