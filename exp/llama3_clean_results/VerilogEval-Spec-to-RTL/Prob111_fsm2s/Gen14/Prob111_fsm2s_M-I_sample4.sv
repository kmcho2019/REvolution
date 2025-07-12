module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// State variable
logic state;

// Output assignment based on state
assign out = state;

// Next state logic with synchronous reset
always_ff @(posedge clk) begin
    if(reset) begin
        // Synchronous reset to state OFF (0)
        state <= 1'b0;
    end else begin
        // Next state logic
        state <= (state == 1'b0)? j : ~k;
    end
end

endmodule