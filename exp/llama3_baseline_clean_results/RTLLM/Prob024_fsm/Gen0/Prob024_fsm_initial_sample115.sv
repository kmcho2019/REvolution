module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

reg [2:0] state;
localparam IDLE = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, MATCHED = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (IN) state <= S1;
                else state <= IDLE;
                MATCH <= 0;
            end
            S1: begin
                if (!IN) state <= S2;
                else state <= S1;
                MATCH <= 0;
            end
            S2: begin
                if (!IN) state <= S3;
                else state <= IDLE;
                MATCH <= 0;
            end
            S3: begin
                if (IN) state <= S4;
                else state <= IDLE;
                MATCH <= 0;
            end
            S4: begin
                if (IN) begin
                    state <= IDLE;
                    MATCH <= 1;
                end
                else state <= IDLE;
            end
            default: begin
                state <= IDLE;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule