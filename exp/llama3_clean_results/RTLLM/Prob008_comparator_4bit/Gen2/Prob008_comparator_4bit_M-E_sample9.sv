module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    A_greater = 0;
    A_equal = 0;
    A_less = 0;
    
    if (A[3] > B[3])
        A_greater = 1;
    else if (A[3] < B[3])
        A_less = 1;
    else
    begin
        if (A[2] > B[2])
            A_greater = 1;
        else if (A[2] < B[2])
            A_less = 1;
        else
        begin
            if (A[1] > B[1])
                A_greater = 1;
            else if (A[1] < B[1])
                A_less = 1;
            else
            begin
                if (A[0] > B[0])
                    A_greater = 1;
                else if (A[0] < B[0])
                    A_less = 1;
                else
                    A_equal = 1;
            end
        end
    end
end

endmodule