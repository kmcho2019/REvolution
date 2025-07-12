module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output reg MATCH
);

reg [2:0] state; // 3-bit state register

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 3'b000; // Reset state
    end else begin
        case (state)
            3'b000: begin
                if (IN) begin
                    state <= 3'b001;
                end
            end
            3'b001: begin
                if (!IN) begin
                    state <= 3'b010;
                end else begin
                    state <= 3'b001;
                end
            end
            3'b010: begin
                if (!IN) begin
                    state <= 3'b011;
                end else begin
                    state <= 3'b001;
                end
            end
            3'b011: begin
                if (IN) begin
                    state <= 3'b100;
                end else begin
                    state <= 3'b001;
                end
            end
            3'b100: begin
                if (IN) begin
                    state <= 3'b100;
                    MATCH <= 1'b1;
                end else begin
                    state <= 3'b001;
                end
            end
            default: state <= 3'b000;
        endcase
    end
end

always @(posedge CLK) begin
    if (state!= 3'b100) begin
        MATCH <= 1'b0;
    end
end

endmodule