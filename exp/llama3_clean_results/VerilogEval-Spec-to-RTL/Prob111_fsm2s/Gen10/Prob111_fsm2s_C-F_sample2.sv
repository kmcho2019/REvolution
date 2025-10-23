module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Single-bit state register
reg next_state; // Next state register

// LUT for next state and output
always_comb begin
    case ({state, j, k})
        3'b000: begin
            next_state = 1'b0;
            out = 1'b0;
        end
        3'b001: begin
            next_state = 1'b0;
            out = 1'b0;
        end
        3'b010: begin
            next_state = 1'b1;
            out = 1'b0;
        end
        3'b011: begin
            next_state = 1'b1;
            out = 1'b0;
        end
        3'b100: begin
            next_state = 1'b1;
            out = 1'b1;
        end
        3'b101: begin
            next_state = 1'b0;
            out = 1'b1;
        end
        3'b110: begin
            next_state = 1'b1;
            out = 1'b1;
        end
        3'b111: begin
            next_state = 1'b0;
            out = 1'b1;
        end
        default: begin
            next_state = 1'b0;
            out = 1'b0;
        end
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

endmodule