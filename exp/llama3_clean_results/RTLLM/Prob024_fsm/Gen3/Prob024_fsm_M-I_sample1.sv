module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [4:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 5'b00000;
        MATCH <= 0;
    end else begin
        case (counter)
            5'b00000: begin
                if (IN) begin
                    counter <= 5'b00001;
                end else begin
                    counter <= 5'b00000;
                end
            end
            5'b00001: begin
                if (!IN) begin
                    counter <= 5'b00010;
                end else begin
                    counter <= 5'b00000;
                end
            end
            5'b00010: begin
                if (!IN) begin
                    counter <= 5'b00100;
                end else begin
                    counter <= 5'b00000;
                end
            end
            5'b00100: begin
                if (IN) begin
                    counter <= 5'b01000;
                end else begin
                    counter <= 5'b00000;
                end
            end
            5'b01000: begin
                if (IN) begin
                    MATCH <= 1;
                    counter <= 5'b00000;
                end else begin
                    counter <= 5'b00000;
                    MATCH <= 0;
                end
            end
            default: begin
                counter <= 5'b00000;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule