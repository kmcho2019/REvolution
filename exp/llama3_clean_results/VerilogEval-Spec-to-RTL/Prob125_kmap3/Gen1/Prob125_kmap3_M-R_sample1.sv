module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output reg out;

    always @(*) begin
        // When c is 0, the output out is 0 when a and b are both 0; otherwise, it is 1.
        // When c is 1, the output out is always 0 when a is 0 and b is 0, and 1 for all other combinations of a and b.
        if (c == 1'b0) begin
            if (a == 1'b0 && b == 1'b0) begin
                out = 1'b0;
            end else begin
                out = 1'b1;
            end
        end else begin
            if (a == 1'b0 && b == 1'b0) begin
                out = 1'b0;
            end else begin
                out = 1'b1;
            end
        end
    end
endmodule