module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 0;
    end else begin
        case (state)
            3'b000: begin
                if (IN) state <= 3'b001;
                else state <= 3'b000;
            end
            3'b001: begin
                if (!IN) state <= 3'b010;
                else state <= 3'b001;
            end
            3'b010: begin
                if (!IN) state <= 3'b011;
                else state <= 3'b001;
            end
            3'b011: begin
                if (IN) state <= 3'b100;
                else state <= 3'b000;
            end
            3'b100: begin
                if (IN) state <= 3'b100;
                else state <= 3'b000;
                MATCH <= 1;
            end
            default: begin
                state <= 3'b000;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule