module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the state counter
logic state_counter;

// Output logic
assign out = state_counter;

// State transition logic using a counter
always_ff @(posedge clk) begin
    if(reset) begin
        state_counter <= 1'b0; // Reset to OFF state
    end else begin
        if (state_counter == 1'b0 && j == 1'b1) begin
            state_counter <= 1'b1; // Transition to ON state
        end else if (state_counter == 1'b1 && k == 1'b1) begin
            state_counter <= 1'b0; // Transition to OFF state
        end
    end
end

endmodule