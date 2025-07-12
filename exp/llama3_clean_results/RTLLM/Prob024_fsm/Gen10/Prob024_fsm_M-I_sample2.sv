module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states using binary encoding
reg [2:0] state; // Binary encoding for states
reg [2:0] next_state; // Next state

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset to S0
        MATCH <= 1'b0;
    end else begin
        case(state)
            3'b000: begin // S0
                if(IN) begin
                    next_state <= 3'b001; // S1
                end else begin
                    next_state <= 3'b000; // S0
                end
                MATCH <= 1'b0;
            end
            3'b001: begin // S1
                if(~IN) begin
                    next_state <= 3'b010; // S2
                end else begin
                    next_state <= 3'b000; // S0
                end
                MATCH <= 1'b0;
            end
            3'b010: begin // S2
                if(~IN) begin
                    next_state <= 3'b011; // S3
                end else begin
                    next_state <= 3'b000; // S0
                end
                MATCH <= 1'b0;
            end
            3'b011: begin // S3
                if(IN) begin
                    next_state <= 3'b100; // S4
                end else begin
                    next_state <= 3'b000; // S0
                end
                MATCH <= 1'b0;
            end
            3'b100: begin // S4
                if(IN) begin
                    next_state <= 3'b100; // S4
                    MATCH <= 1'b1; // Set MATCH to 1 when sequence is 10011
                end else begin
                    next_state <= 3'b000; // S0
                    MATCH <= 1'b0;
                end
            end
            default: begin
                next_state <= 3'b000; // S0
                MATCH <= 1'b0;
            end
        endcase
        state <= next_state;
    end
end

endmodule