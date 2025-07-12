module TopModule(
    input x,
    input y,
    output reg z
);
    reg state;

    always @(*)
    begin
        if (x == y)
            state = 1'b1;
        else
            state = 1'b0;
    end

    always @(*)
    begin
        z = state;
    end
endmodule