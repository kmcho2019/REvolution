module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [3:0] state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 4'b0000;
        MATCH <= 0;
    end else begin
        case (state)
            4'b0000: begin
                if (IN) begin
                    state <= 4'b0001;
                end
            end
            4'b0001: begin
                if (!IN) begin
                    state <= 4'b0010;
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b0010: begin
                if (!IN) begin
                    state <= 4'b0011;
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b0011: begin
                if (IN) begin
                    state <= 4'b0100;
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b0100: begin
                if (IN) begin
                    MATCH <= 1;
                    state <= 4'b0000;
                end else begin
                    state <= 4'b0000;
                    MATCH <= 0;
                end
            end
            default: begin
                state <= 4'b0000;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule