module TopModule(input a, b, output reg out);
    always @(a or b) begin
        out = ~(a | b);
    end
endmodule