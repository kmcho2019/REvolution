module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [3:0] current_state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= 4'b0000;
    end else begin
        case (current_state)
            4'b0000: begin
                if (IN) begin
                    current_state <= 4'b0001;
                end else begin
                    current_state <= 4'b0000;
                end
            end
            4'b0001: begin
                if (!IN) begin
                    current_state <= 4'b0010;
                end else begin
                    current_state <= 4'b0000;
                end
            end
            4'b0010: begin
                if (!IN) begin
                    current_state <= 4'b0100;
                end else begin
                    current_state <= 4'b0000;
                end
            end
            4'b0100: begin
                if (IN) begin
                    current_state <= 4'b1000;
                end else begin
                    current_state <= 4'b0000;
                end
            end
            4'b1000: begin
                if (IN) begin
                    current_state <= 4'b1000;
                    MATCH <= 1'b1;
                end else begin
                    current_state <= 4'b0000;
                    MATCH <= 1'b0;
                end
            end
            default: begin
                current_state <= 4'b0000;
            end
        endcase
    end
end

// No need for an assign statement for MATCH, it is handled in the always block

endmodule