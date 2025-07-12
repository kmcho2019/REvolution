module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// State register
reg state;

// Output assignment based on current state
assign out = ~state; // Out is 1 in state B (0) and 0 in state A (1)

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        state <= 0;
    end else if (state == 0) begin
        state <= in;
    end else begin
        state <= ~in;
    end
end

endmodule