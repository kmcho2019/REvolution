module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [1:0] state; // 4-state machine

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 2'b00;
        MATCH <= 0;
    end else begin
        case (state)
            2'b00: begin // Initial state
                if (IN) state <= 2'b01;
                else state <= 2'b00;
            end
            2'b01: begin // First '1' detected
                if (!IN) state <= 2'b10;
                else state <= 2'b01;
            end
            2'b10: begin // First '0' detected
                if (!IN) state <= 2'b11;
                else state <= 2'b01;
            end
            2'b11: begin // Second '0' detected
                if (IN) state <= 2'b00; // Reset to initial state
                else state <= 2'b11;
                MATCH <= IN; // Assert MATCH if IN is '1'
            end
            default: begin
                state <= 2'b00;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule