module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] current_state;
reg clk_enable;

// Apply clock gating to reduce power consumption
assign clk_enable = (current_state != 3'b100) || IN;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= 3'b000;
        MATCH <= 1'b0;
    end else if (clk_enable) begin
        case (current_state)
            3'b000: begin
                if (IN) begin
                    current_state <= 3'b001;
                end
            end
            3'b001: begin
                if (!IN) begin
                    current_state <= 3'b010;
                end else begin
                    current_state <= 3'b000;
                end
            end
            3'b010: begin
                if (!IN) begin
                    current_state <= 3'b011;
                end else begin
                    current_state <= 3'b000;
                end
            end
            3'b011: begin
                if (IN) begin
                    current_state <= 3'b100;
                end else begin
                    current_state <= 3'b000;
                end
            end
            3'b100: begin
                if (IN) begin
                    current_state <= 3'b000;
                    MATCH <= 1'b1;
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