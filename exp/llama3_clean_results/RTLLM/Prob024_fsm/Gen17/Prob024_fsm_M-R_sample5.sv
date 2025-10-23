module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state register
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

// FSM state transitions
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0; // Reset state
    end else begin
        case (state)
            S0: if (IN) state <= S1; else state <= S0;
            S1: if (!IN) state <= S2; else state <= S1;
            S2: if (!IN) state <= S3; else state <= S1;
            S3: if (IN) state <= S4; else state <= S1;
            S4: if (IN) state <= S4; else state <= S1;
            default: state <= S0;
        endcase
    end
end

// Continuous assignment for MATCH signal
assign MATCH = (state == S4) ? 1'b1 : 1'b0;

endmodule