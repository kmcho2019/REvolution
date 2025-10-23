module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// State variable
logic state;

// Next state logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        case(state)
            0: state <= j ? 1 : 0; // OFF state
            1: state <= ~k ? 1 : 0; // ON state
        endcase
    end
end

// Output assignment based on state
assign out = state;

endmodule