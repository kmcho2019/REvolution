module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] counter;
reg flag_start, flag_zero, flag_zero2;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <='b000;
        flag_start <= 0;
        flag_zero1 <= 0;
        flag_zero2 <= 0;
        MATCH <= 0;
    end else begin
        case (counter)
'b000: begin
                if (IN) begin
                    counter <= 3'b001;
                    flag_start <= 1;
                end else begin
                    flag_start <= 0;
                end
            end
            3'b001: begin
                if (!IN) begin
                    counter <= 3'b010;
                    flag_zero1 <= 1;
                end else begin
                    counter <= 3'b000;
                    flag_start <= 0;
                    flag_zero1 <= 0;
                    flag_zero2 <= 0;
                end
            end
            3'b010: begin
                if (!IN) begin
                    counter <= 3'b011;
                    flag_zero2 <= 1;
                end else begin
                    counter <= 3'b000;
                    flag_start <= 0;
                    flag_zero1 <= 0;
                    flag_zero2 <= 0;
                end
            end
            3'b011: begin
                if (IN) begin
                    counter <= 3'b100;
                end else begin
                    counter <= 3'b000;
                    flag_start <= 0;
                    flag_zero1 <= 0;
                    flag_zero2 <= 0;
                end
            end
            3'b100: begin
                if (IN) begin
                    MATCH <= 1;
                    counter <= 3'b000;
                    flag_start <= 0;
                    flag_zero1 <= 0;
                    flag_zero2 <= 0;
                end else begin
                    counter <= 3'b000;
                    flag_start <= 0;
                    flag_zero1 <= 0;
                    flag_zero2 <= 0;
                    MATCH <= 0;
                end
            end
            default: begin
                counter <= 3'b000;
                flag_start <= 0;
                flag_zero1 <= 0;
                flag_zero2 <= 0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule