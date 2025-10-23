module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    case ({A, B})
        default: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 0;
        end
        // A > B
        {3'b000, 3'b000}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        {3'b001, 3'b000}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b010, 3'b000}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b011, 3'b000}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b100, 3'b000}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b101, 3'b000}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b110, 3'b000}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b111, 3'b000}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b000, 3'b001}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b001, 3'b001}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        {3'b010, 3'b001}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b011, 3'b001}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b100, 3'b001}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b101, 3'b001}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b110, 3'b001}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b111, 3'b001}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b000, 3'b010}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b001, 3'b010}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b010, 3'b010}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        {3'b011, 3'b010}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b100, 3'b010}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b101, 3'b010}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b110, 3'b010}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b111, 3'b010}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b000, 3'b011}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b001, 3'b011}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b010, 3'b011}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b011, 3'b011}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        {3'b100, 3'b011}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b101, 3'b011}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b110, 3'b011}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b111, 3'b011}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b000, 3'b100}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b001, 3'b100}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b010, 3'b100}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b011, 3'b100}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b100, 3'b100}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        {3'b101, 3'b100}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b110, 3'b100}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b111, 3'b100}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b000, 3'b101}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b001, 3'b101}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b010, 3'b101}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b011, 3'b101}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b100, 3'b101}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b101, 3'b101}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        {3'b110, 3'b101}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b111, 3'b101}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b000, 3'b110}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b001, 3'b110}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b010, 3'b110}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b011, 3'b110}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b100, 3'b110}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b101, 3'b110}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b110, 3'b110}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        {3'b111, 3'b110}: begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
        {3'b000, 3'b111}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b001, 3'b111}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b010, 3'b111}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b011, 3'b111}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b100, 3'b111}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b101, 3'b111}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b110, 3'b111}: begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        {3'b111, 3'b111}: begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
    endcase
end

endmodule