module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Current state register
reg current_state;

// Initialize output
assign out = current_state;

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0;
    end else begin
        case (current_state)
            0: current_state <= j ? 1 : 0;
            1: current_state <= k ? 0 : 1;
        endcase
    end
end

endmodule