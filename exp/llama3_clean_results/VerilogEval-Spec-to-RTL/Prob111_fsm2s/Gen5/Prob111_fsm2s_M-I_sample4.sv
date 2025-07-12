module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define an enumeration for the states for clarity and ease of use
typedef enum logic [0:0] {
    OFF,
    ON
} state_type;

reg state_type current_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF; // Reset to OFF state
    end else begin
        case(current_state)
            OFF: current_state <= j ? ON : OFF; // Transition from OFF based on j
            ON:  current_state <= ~k ? ON : OFF; // Transition from ON based on k
        endcase
    end
end

assign out = (current_state == ON) ? 1'b1 : 1'b0; // Output is 1 when in ON state

endmodule