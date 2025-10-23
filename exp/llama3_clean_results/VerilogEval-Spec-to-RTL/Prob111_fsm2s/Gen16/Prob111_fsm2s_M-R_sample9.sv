module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

// Define the states as an enumeration
typedef enum logic [0:0] {
    OFF,
    ON
} state_type;

// State variable
state_type state;

// Next state logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: state <= j ? ON : OFF;
            ON: state <= ~k ? ON : OFF;
        endcase
    end
end

// Output assignment based on state
assign out = state == ON;

endmodule