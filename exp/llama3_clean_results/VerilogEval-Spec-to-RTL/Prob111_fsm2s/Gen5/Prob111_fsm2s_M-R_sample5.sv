module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

reg state;

// State register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= OFF; // Reset to OFF state
    end else begin
        case(state)
            OFF: state <= (j) ? ON : OFF;
            ON:  state <= (!k) ? ON : OFF;
            default: state <= OFF; // Default to OFF state
        endcase
    end
end

// Output logic based on current state
always @(*) begin
    case(state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'b0; // Default output to 0
    endcase
end

endmodule