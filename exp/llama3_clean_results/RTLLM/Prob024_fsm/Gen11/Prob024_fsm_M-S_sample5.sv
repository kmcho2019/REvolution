module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states sequentially
reg [2:0] state; // Sequential state encoding (0 to 4)
reg [2:0] next_state;

// Sequential logic for state update and output
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= 3'b000; // Reset to S0
        MATCH <= 1'b0;
    end else begin
        case(state)
            3'b000: begin // S0
                next_state <= IN ? 3'b001 : 3'b000; // S1 if IN=1, else S0
                MATCH <= 1'b0;
            end
            3'b001: begin // S1
                next_state <= ~IN ? 3'b010 : 3'b000; // S2 if IN=0, else S0
                MATCH <= 1'b0;
            end
            3'b010: begin // S2
                next_state <= ~IN ? 3'b011 : 3'b000; // S3 if IN=0, else S0
                MATCH <= 1'b0;
            end
            3'b011: begin // S3
                next_state <= IN ? 3'b100 : 3'b000; // S4 if IN=1, else S0
                MATCH <= 1'b0;
            end
            3'b100: begin // S4
                MATCH <= IN ? 1'b1 : 1'b0; // MATCH=1 if IN=1 in S4
                next_state <= IN ? 3'b100 : 3'b000; // Stay in S4 if IN=1, else S0
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