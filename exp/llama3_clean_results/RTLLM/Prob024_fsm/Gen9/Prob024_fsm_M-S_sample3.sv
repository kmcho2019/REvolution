module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 0;
    end else begin
        case (state)
            3'b000: begin // Initial state
                if (IN) state <= 3'b001;
                else state <= 3'b000;
            end
            3'b001: begin // First '1' detected
                if (!IN) state <= 3'b010;
                else state <= 3'b001;
            end
            3'b010: begin // First '0' detected
                if (!IN) state <= 3'b011;
                else state <= 3'b001;
            end
            3'b011: begin // Second '0' detected
                if (IN) state <= 3'b100;
                else state <= 3'b011;
            end
            3'b100: begin // Third '1' detected
                if (IN) state <= 3'b101;
                else state <= 3'b000;
            end
            3'b101: begin // Fourth '1' detected
                MATCH <= 1;
                state <= 3'b000;
            end
            default: begin
                state <= 3'b000;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule