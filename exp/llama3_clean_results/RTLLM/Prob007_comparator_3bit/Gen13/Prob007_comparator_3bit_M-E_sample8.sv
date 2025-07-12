module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

reg [1:0] state;

always @(*)
begin
    case(state)
        2'b00: // Initial state
            begin
                if (A > B)
                    state = 2'b10; // A > B
                else if (A == B)
                    state = 2'b01; // A == B
                else
                    state = 2'b00; // A < B
            end
        2'b10: // A > B
            begin
                A_greater = 1'b1;
                A_equal = 1'b0;
                A_less = 1'b0;
            end
        2'b01: // A == B
            begin
                A_greater = 1'b0;
                A_equal = 1'b1;
                A_less = 1'b0;
            end
        default: // A < B
            begin
                A_greater = 1'b0;
                A_equal = 1'b0;
                A_less = 1'b1;
            end
    endcase
end

endmodule