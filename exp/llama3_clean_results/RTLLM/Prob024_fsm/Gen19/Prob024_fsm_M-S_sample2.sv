module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 5-state Mealy machine

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state machine
        MATCH <= 1'b0;
    end else begin
        case (state)
            3'b000: begin
                if (IN) state <= 3'b001; // Sequence starts with 1
            end
            3'b001: begin
                if (!IN) state <= 3'b010; // Sequence continues with 0
                else state <= 3'b001; // Still waiting for 0
            end
            3'b010: begin
                if (!IN) state <= 3'b011; // Sequence continues with 0
                else state <= 3'b001; // Restart sequence
            end
            3'b011: begin
                if (IN) state <= 3'b100; // Sequence continues with 1
                else state <= 3'b001; // Restart sequence
            end
            3'b100: begin
                if (IN) begin
                    MATCH <= 1'b1; // Set MATCH signal
                    state <= 3'b000; // Sequence detected, reset state machine
                end else state <= 3'b001; // Restart sequence
            end
        endcase
    end
end

endmodule