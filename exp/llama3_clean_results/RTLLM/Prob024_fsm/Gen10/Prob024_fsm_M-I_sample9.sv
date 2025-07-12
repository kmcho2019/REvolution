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
                next_state <= IN ? 5'b01000 : 5'b10000; // S1 if IN=1, else S0
                MATCH <= 1'b0;
            end
            5'b01000: begin // S1
                next_state <= ~IN ? 5'b00100 : 5'b10000; // S2 if IN=0, else S0
                MATCH <= 1'b0;
            end
            5'b00100: begin // S2
                next_state <= ~IN ? 5'b00010 : 5'b10000; // S3 if IN=0, else S0
                MATCH <= 1'b0;
            end
            5'b00010: begin // S3
                next_state <= IN ? 5'b00001 : 5'b10000; // S4 if IN=1, else S0
                MATCH <= 1'b0;
            end
            5'b00001: begin // S4
                next_state <= IN ? 5'b00001 : 5'b10000; // Stay in S4 if IN=1, else S0
                MATCH <= IN ? 1'b1 : 1'b0; // MATCH=1 if IN=1 in S4
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