module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states using one-hot encoding
reg [4:0] state; // One-hot encoding for states
reg [4:0] next_state; // Next state

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 5'b10000; // Reset to S0
        MATCH <= 1'b0;
    end else begin
        case(state)
            5'b10000: begin // S0
                if(IN) begin
                    next_state <= 5'b01000; // S1
                    MATCH <= 1'b0;
                end else begin
                    next_state <= 5'b10000; // S0
                    MATCH <= 1'b0;
                end
            end
            5'b01000: begin // S1
                if(~IN) begin
                    next_state <= 5'b00100; // S2
                    MATCH <= 1'b0;
                end else begin
                    next_state <= 5'b10000; // S0
                    MATCH <= 1'b0;
                end
            end
            5'b00100: begin // S2
                if(~IN) begin
                    next_state <= 5'b00010; // S3
                    MATCH <= 1'b0;
                end else begin
                    next_state <= 5'b10000; // S0
                    MATCH <= 1'b0;
                end
            end
            5'b00010: begin // S3
                if(IN) begin
                    next_state <= 5'b00001; // S4
                    MATCH <= 1'b0;
                end else begin
                    next_state <= 5'b10000; // S0
                    MATCH <= 1'b0;
                end
            end
            5'b00001: begin // S4
                if(IN) begin
                    next_state <= 5'b00001; // S4
                    MATCH <= 1'b1; // Set MATCH to 1 when sequence is 10011
                end else begin
                    next_state <= 5'b10000; // S0
                    MATCH <= 1'b0;
                end
            end
            default: begin
                next_state <= 5'b10000; // S0
                MATCH <= 1'b0;
            end
        endcase
        state <= next_state;
    end
end

endmodule