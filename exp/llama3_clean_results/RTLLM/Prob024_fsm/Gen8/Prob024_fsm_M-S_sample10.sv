module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

reg [2:0] state; // 3-bit state register (5 states)

// State machine logic
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset state machine
        MATCH <= 1'b0;
    end else begin
        case(state)
            3'b000: begin // State 0: Wait for first '1'
                if(IN) begin
                    state <= 3'b001;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin // State 1: Wait for first '0'
                if(!IN) begin
                    state <= 3'b010;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b010: begin // State 2: Wait for second '0'
                if(!IN) begin
                    state <= 3'b011;
                end else begin
                    state <= 3'b001;
                end
            end
            3'b011: begin // State 3: Wait for first '1'
                if(IN) begin
                    state <= 3'b100;
                end else begin
                    state <= 3'b011;
                end
            end
            3'b100: begin // State 4: Wait for second '1'
                if(IN) begin
                    MATCH <= 1'b1;
                    state <= 3'b100;
                end else begin
                    state <= 3'b011;
                end
            end
        endcase
    end
end

// Reset MATCH signal when not in final state
always @(posedge CLK) begin
    if(state != 3'b100 || !IN) begin
        MATCH <= 1'b0;
    end
end

endmodule