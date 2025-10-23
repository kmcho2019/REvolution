module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // IDLE, S1, S2, S3, S4, S5

localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

always @(posedge CLK or negedge RST) begin
    if (~RST) begin // reset
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
                if (~IN) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 0;
            end
            S2: begin
                if (~IN) begin
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
                    state <= S5;
                end else begin
                    state <= IDLE;
                end
                MATCH <= 0;
            end
            S5: begin
                if (IN) begin
                    MATCH <= 1;
                    state <= S5;
                end else begin
                    state <= IDLE;
                    MATCH <= 0;
                end
            end
        endcase
    end
end

endmodule