module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    // Default assignments
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;
    
    case(1'b1)
        (A > B): A_greater = 1'b1;
        (A == B): A_equal = 1'b1;
        (A < B): A_less = 1'b1;
    endcase
end

endmodule