module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 6-state Mealy machine
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0; // Reset state machine
        MATCH <= 1'b0;
    end else begin
        case (state)
            S0: begin
                if (IN) state <= S1; // Sequence starts with 1
                else state <= S0; // Still waiting for 1
            end
            S1: begin
                if (!IN) state <= S2; // Sequence continues with 0
                else state <= S1; // Still waiting for 0
            end
            S2: begin
                if (!IN) state <= S3; // Sequence continues with 0
                else state <= S1; // Restart sequence
            end
            S3: begin
                if (IN) state <= S4; // Sequence continues with 1
                else state <= S1; // Restart sequence
            end
            S4: begin
                if (IN) state <= S5; // Sequence continues with 1
                else state <= S1; // Restart sequence
            end
            S5: begin
                MATCH <= 1'b1; // Set MATCH signal
                if (IN) state <= S5; // Stay in S5 if input is 1
                else state <= S1; // Restart sequence
            end
            default: state <= S0; // Invalid state, reset state machine
        endcase
    end
end

endmodule