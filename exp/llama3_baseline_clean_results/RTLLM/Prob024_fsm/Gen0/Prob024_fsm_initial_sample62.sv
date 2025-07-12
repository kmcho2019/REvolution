module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] current_state;

localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam MATCH_STATE = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
        MATCH <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (IN) begin
                    current_state <= S1;
                    MATCH <= 0;
                end else begin
                    current_state <= IDLE;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (!IN) begin
                    current_state <= S2;
                    MATCH <= 0;
                end else begin
                    current_state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (!IN) begin
                    current_state <= S3;
                    MATCH <= 0;
                end else begin
                    current_state <= IDLE;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN) begin
                    current_state <= S4;
                    MATCH <= 0;
                end else begin
                    current_state <= IDLE;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN) begin
                    current_state <= MATCH_STATE;
                    MATCH <= 1;
                end else begin
                    current_state <= IDLE;
                    MATCH <= 0;
                end
            end
            MATCH_STATE: begin
                if (IN) begin
                    current_state <= S1;
                    MATCH <= 0;
                end else begin
                    current_state <= IDLE;
                    MATCH <= 0;
                end
            end
            default: begin
                current_state <= IDLE;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule