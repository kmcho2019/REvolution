module fsm(
    input IN,  // Input signal to the FSM
    input CLK,  // Clock signal used for synchronous operation
    input RST,  // Reset signal to initialize the FSM
    output reg MATCH  // Output signal indicating a match condition based on the FSM state
);

reg [2:0] state;  // Current state of the FSM
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin  // Reset the FSM
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (~IN) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (~IN) begin
                    state <= S3;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                state <= S0;
                MATCH <= 0;
            end
            default: begin
                state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule