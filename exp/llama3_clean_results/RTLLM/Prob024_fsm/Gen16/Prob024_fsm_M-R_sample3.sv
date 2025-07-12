module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state register
localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0; // Reset state machine
    end else begin
        case (state)
            S0: begin
                if (IN) state <= S1; // Transition to S1 on '1'
                else state <= S0; // Stay in S0 on '0'
            end
            S1: begin
                if (!IN) state <= S2; // Transition to S2 on '0'
                else state <= S1; // Stay in S1 on '1'
            end
            S2: begin
                if (!IN) state <= S3; // Transition to S3 on '0'
                else state <= S1; // Go back to S1 on '1'
            end
            S3: begin
                if (IN) state <= S4; // Transition to S4 on '1'
                else state <= S2; // Go back to S2 on '0'
            end
            S4: begin
                if (IN) state <= S5; // Transition to S5 on '1'
                else state <= S2; // Go back to S2 on '0'
            end
            S5: begin
                if (IN) state <= S5; // Stay in S5 on '1'
                else state <= S0; // Go back to S0 on '0'
            end
            default: state <= S0; // Default state
        endcase
    end
end

assign MATCH = (state == S5); // Assert MATCH signal in state S5

endmodule