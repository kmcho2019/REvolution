module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] current_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= 3'b000;
        MATCH <= 1'b0;
    end else begin
        case (current_state)
            3'b000: begin
                if (IN) begin
                    current_state <= 3'b001;
                    MATCH <= 1'b0;
                end else begin
                    current_state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b001: begin
                if (!IN) begin
                    current_state <= 3'b010;
                    MATCH <= 1'b0;
                end else begin
                    current_state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b010: begin
                if (!IN) begin
                    current_state <= 3'b011;
                    MATCH <= 1'b0;
                end else begin
                    current_state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b011: begin
                if (IN) begin
                    current_state <= 3'b100;
                    MATCH <= 1'b0;
                end else begin
                    current_state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            3'b100: begin
                if (IN) begin
                    MATCH <= 1'b1;
                    current_state <= 3'b100;
                end else begin
                    current_state <= 3'b000;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                current_state <= 3'b000;
                MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule