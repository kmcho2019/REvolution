module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // Two-bit state register (OFF=2'b00, ON=2'b01)

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to OFF state
    end else begin
        case (state)
            2'b00: // OFF state
                if (j) begin
                    state <= 2'b01; // Transition to ON state
                end else begin
                    state <= 2'b00; // Remain in OFF state
                end
            2'b01: // ON state
                if (k) begin
                    state <= 2'b00; // Transition to OFF state
                end else begin
                    state <= 2'b01; // Remain in ON state
                end
            default: // Default to OFF state
                state <= 2'b00;
        endcase
    end
end

always_comb begin
    case (state)
        2'b00: // OFF state
            out = 1'b0;
        2'b01: // ON state
            out = 1'b1;
        default: // Default to OFF state
            out = 1'b0;
    endcase
end

endmodule