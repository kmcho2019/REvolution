module TopModule (input a, b, c, d, output reg q);
    always @(a or b or c or d) begin
        q = b | c;
    end
endmodule