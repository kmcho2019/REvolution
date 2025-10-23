module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    reg greater_flag;
    reg less_flag;

    always @(*)
    begin
        A_greater = 0;
        A_equal = 0;
        A_less = 0;
        greater_flag = 0;
        less_flag = 0;

        for (int i = 3; i >= 0; i--)
        begin
            if (greater_flag == 1)
            begin
                A_greater = 1;
                break;
            end
            else if (less_flag == 1)
            begin
                A_less = 1;
                break;
            end
            else if (A[i] == 1 && B[i] == 0)
            begin
                greater_flag = 1;
                A_greater = 1;
                break;
            end
            else if (A[i] == 0 && B[i] == 1)
            begin
                less_flag = 1;
                A_less = 1;
                break;
            end
        end

        if (A_greater == 0 && A_less == 0)
        begin
            A_equal = 1;
        end
    end

endmodule