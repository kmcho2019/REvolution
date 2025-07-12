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
    end else if (state == 1'b0 && j == 1'b1) begin
        state <= 1'b1; // Transition to ON state if j is 1
    end else if (state == 1'b1 && k == 1'b1) begin
        state <= 1'b0; // Transition to OFF state if k is 1
    end
end

endmodule