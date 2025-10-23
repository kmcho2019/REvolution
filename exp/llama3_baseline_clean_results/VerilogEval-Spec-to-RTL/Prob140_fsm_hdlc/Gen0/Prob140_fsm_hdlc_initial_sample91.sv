module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // Using 3 bits to represent states S0 to S7 (though S7 is actually S_ERR)
reg [2:0] nextState;

// Outputs
assign disc = (state == 3'b101); // S5, about to enter S6, so discard
assign flag = (state == 3'b110 && in == 1'b0); // In S6 and got a 0, so flag
assign err = (state == 3'b111); // In error state

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to S0
    end else begin
        case (state)
            3'b000: // S0
                if (in) state <= 3'b001; // Move to S1
                else state <= 3'b000; // Stay in S0
            3'b001: // S1
                if (in) state <= 3'b010; // Move to S2
                else state <= 3'b000; // Back to S0
            3'b010: // S2
                if (in) state <= 3'b011; // Move to S3
                else state <= 3'b000; // Back to S0
            3'b011: // S3
                if (in) state <= 3'b100; // Move to S4
                else state <= 3'b000; // Back to S0
            3'b100: // S4
                if (in) state <= 3'b101; // Move to S5
                else state <= 3'b000; // Back to S0
            3'b101: // S5
                if (in) state <= 3'b110; // Move to S6
                else state <= 3'b000; // Back to S0
            3'b110: // S6
                if (in) state <= 3'b111; // Error, move to S_ERR
                else state <= 3'b000; // Flag detected, back to S0
            3'b111: // S_ERR
                if (!in) state <= 3'b000; // Reset to S0 on seeing a 0
                else state <= 3'b111; // Stay in error state
            default: state <= 3'b000; // Default to S0
        endcase
    end
end

endmodule