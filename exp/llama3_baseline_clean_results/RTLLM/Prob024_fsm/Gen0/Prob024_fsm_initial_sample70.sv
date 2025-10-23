module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state;

parameter IDLE = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter MATCH_STATE = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (IN) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 0;
            end
            S1: begin
                if (!IN) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 0;
            end
            S2: begin
                if (!IN) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 0;
            end
            S3: begin
                if (IN) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 0;
            end
            S4: begin
                if (IN) begin
                    state <= MATCH_STATE;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 0;
            end
            MATCH_STATE: begin
                state <= IDLE;
                MATCH <= 1;
            end
            default: begin
                state <= IDLE;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule