module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Explicitly define two states (OFF and ON)

// Output logic based on current state
always_comb begin
    case (state)
        2'b00: out = 1'b0; // OFF state
        2'b01: out = 1'b1; // ON state
        default: out = 1'b0; // Default to OFF for invalid states
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to OFF state
    end else begin
        case (state)
            2'b00: state <= (j) ? 2'b01 : 2'b00; // OFF state transitions
            2'b01: state <= (!k) ? 2'b01 : 2'b00; // ON state transitions
            default: state <= 2'b00; // Reset to OFF for invalid states
        endcase
    end
end

endmodule