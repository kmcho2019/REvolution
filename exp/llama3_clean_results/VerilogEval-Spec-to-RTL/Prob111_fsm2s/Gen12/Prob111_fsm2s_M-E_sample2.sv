module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

// Combinational logic block with LUT
always_comb begin
    case ({state, j, k})
        3'b000: out = 1'b0; // OFF state, j=0, k=0
        3'b001: out = 1'b0; // OFF state, j=0, k=1
        3'b010: out = 1'b1; // OFF state, j=1, k=0
        3'b011: out = 1'b1; // OFF state, j=1, k=1
        3'b100: out = 1'b1; // ON state, j=0, k=0
        3'b101: out = 1'b0; // ON state, j=0, k=1
        3'b110: out = 1'b1; // ON state, j=1, k=0
        3'b111: out = 1'b0; // ON state, j=1, k=1
        default: out = 1'b0; // Default output for invalid states
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        case ({state, j, k})
            3'b000: state <= 1'b0; // OFF state, j=0, k=0
            3'b001: state <= 1'b0; // OFF state, j=0, k=1
            3'b010: state <= 1'b1; // OFF state, j=1, k=0
            3'b011: state <= 1'b1; // OFF state, j=1, k=1
            3'b100: state <= 1'b1; // ON state, j=0, k=0
            3'b101: state <= 1'b0; // ON state, j=0, k=1
            3'b110: state <= 1'b1; // ON state, j=1, k=0
            3'b111: state <= 1'b0; // ON state, j=1, k=1
            default: state <= 1'b0; // Default state for invalid states
        endcase
    end
end

endmodule