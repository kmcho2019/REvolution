module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// State register update and next-state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0;
    end else begin
        if (current_state == 1'b0) begin
            current_state <= j? 1'b1 : 1'b0;
        end else begin
            current_state <= ~k? 1'b1 : 1'b0;
        end
    end
end

// Output logic directly from state
assign out = current_state;

endmodule