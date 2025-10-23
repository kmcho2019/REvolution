// Define the states as enumeration
enum logic {OFF, ON} current_state, next_state;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

// State register update and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: current_state <= (j)? ON : OFF;
            ON:  current_state <= (~k)? ON : OFF;
            default: current_state <= OFF;
        endcase
    end
end

// Output logic directly from state
assign out = (current_state == ON)? 1'b1 : 1'b0;

endmodule