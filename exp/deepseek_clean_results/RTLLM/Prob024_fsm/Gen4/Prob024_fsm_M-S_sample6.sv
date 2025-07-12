module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// State encoding with 5 states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
parameter S4 = 3'b100; // Extra bit for 5th state

reg [2:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                MATCH <= 0;
                state <= IN ? S1 : S0;
            end
            S1: begin
                MATCH <= 0;
                state <= IN ? S1 : S2;
            end
            S2: begin
                MATCH <= 0;
                state <= IN ? S1 : S3;
            end
            S3: begin
                MATCH <= 0;
                state <= IN ? S4 : S0;
            end
            S4: begin
                MATCH <= IN; // Output 1 only if IN=1 at this state
                state <= IN ? S1 : S2;
            end
            default: state <= S0;
        endcase
    end
end

endmodule