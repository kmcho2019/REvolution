module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the state
logic state;

// Output logic
assign out = state;

// State transition logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset to OFF state
    end else if(state == 1'b0) begin // Currently in OFF state
        state <= j? 1'b1 : 1'b0; // Transition to ON state if j is 1
    end else begin // Currently in ON state
        state <= k? 1'b0 : 1'b1; // Transition to OFF state if k is 1
    end
end

endmodule