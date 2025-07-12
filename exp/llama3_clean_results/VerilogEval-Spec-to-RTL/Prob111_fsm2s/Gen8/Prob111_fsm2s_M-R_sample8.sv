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

// Next state logic
logic next_state;
assign next_state = reset ? 1'b0 :
                    state ? (~k ? 1'b1 : 1'b0) :
                              (j ? 1'b1 : 1'b0);

// State transition logic
always_ff @(posedge clk) begin
    state <= next_state;
end

endmodule