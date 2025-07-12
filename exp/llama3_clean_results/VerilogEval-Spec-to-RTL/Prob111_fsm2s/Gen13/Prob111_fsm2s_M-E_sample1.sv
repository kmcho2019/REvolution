module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single flip-flop for OFF (0) and ON (1) states

// Lookup table (LUT) for next state and output
always_comb begin
    case ({state, j, k})
        3'b000: begin state <= 1'b0; out <= 1'b0; end // OFF, j=0, k=0
        3'b001: begin state <= 1'b0; out <= 1'b0; end // OFF, j=0, k=1
        3'b010: begin state <= 1'b1; out <= 1'b0; end // OFF, j=1, k=0
        3'b011: begin state <= 1'b1; out <= 1'b0; end // OFF, j=1, k=1
        3'b100: begin state <= 1'b1; out <= 1'b1; end // ON, j=0, k=0
        3'b101: begin state <= 1'b1; out <= 1'b1; end // ON, j=0, k=1
        3'b110: begin state <= 1'b0; out <= 1'b1; end // ON, j=1, k=0
        3'b111: begin state <= 1'b0; out <= 1'b1; end // ON, j=1, k=1
        default: begin state <= 1'b0; out <= 1'b0; end
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        // Do nothing, state is updated in the always_comb block
    end
end

endmodule