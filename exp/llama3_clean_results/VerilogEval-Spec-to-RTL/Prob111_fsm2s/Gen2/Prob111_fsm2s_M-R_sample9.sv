module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Enumerate the states
enum logic [0:0] {OFF, ON} state;

// Output logic based on current state
assign out = (state == ON)? 1'b1 : 1'b0;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        case(state)
            OFF: state <= (j == 1'b1)? ON : OFF;
            ON:  state <= (k == 1'b1)? OFF : ON;
            default: state <= OFF;
        endcase
    end
end

endmodule