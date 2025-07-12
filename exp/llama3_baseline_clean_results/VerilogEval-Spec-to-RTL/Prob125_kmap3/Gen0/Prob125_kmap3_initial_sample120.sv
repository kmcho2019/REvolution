module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    always @(*) begin
        if (c == 1) begin
            out = 1;
        end else if (a == 0 && b == 0) begin
            out = 0;
        end else if (a == 0 && b == 1 || a == 1 && b == 0) begin
            out = 1;
        end else if (a == 1 && b == 1) begin
            out = 1;  // This is the case for a=1, b=1 and c=0
        end
    end

endmodule