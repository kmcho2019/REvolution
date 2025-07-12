module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

parameter IDLE = 4'b0000;
parameter S1    = 4'b0001;
parameter S2    = 4'b0010;
parameter S3    = 4'b0100;
parameter S4    = 4'b1000;

reg [3:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= IDLE;
        MATCH <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (IN == 1) state <= S1;
            end
            S1: begin
                if (IN == 0) state <= S2;
                else state <= S1;
            end
            S2: begin
                if (IN == 0) state <= S3;
                else state <= S1;
            end
            S3: begin
                if (IN == 1) state <= S4;
                else state <= S1;
            end
            S4: begin
                if (IN == 1) begin
                    MATCH <= 1;
                    state <= S1;
                end
                else state <= S1;
            end
        endcase
    end
end

endmodule