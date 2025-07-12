module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 6-state machine

// State transition logic
always @(posedge CLK) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 0;
    end else begin
        case (state)
            3'b000: if (IN) state <= 3'b001; else state <= 3'b000;
            3'b001: if (!IN) state <= 3'b010; else state <= 3'b001;
            3'b010: if (!IN) state <= 3'b011; else state <= 3'b001;
            3'b011: if (IN) state <= 3'b100; else state <= 3'b011;
            3'b100: if (IN) state <= 3'b101; else state <= 3'b000;
            3'b101: state <= 3'b000;
            default: state <= 3'b000;
        endcase
        
        // Assert MATCH signal only when in the final state of the sequence
        if (state == 3'b101) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule