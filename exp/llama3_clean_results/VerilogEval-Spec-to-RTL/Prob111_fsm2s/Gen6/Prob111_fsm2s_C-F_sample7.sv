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
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case(state)
            1'b0: state <= j? 1'b1 : 1'b0; // Transition to ON state if j is 1
            1'b1: state <= ~k? 1'b1 : 1'b0; // Transition to OFF state if k is 1
        endcase
    end
end

endmodule