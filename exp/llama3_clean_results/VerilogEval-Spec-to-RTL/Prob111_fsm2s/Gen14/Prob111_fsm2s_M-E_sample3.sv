module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define an enumeration for the states
enum logic [0:0] {OFF, ON} state, next_state;

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

// State transition logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case (state)
            OFF: state <= (j) ? ON : OFF;
            ON: state <= (~k) ? ON : OFF;
            default: state <= OFF;
        endcase
    end
end

endmodule