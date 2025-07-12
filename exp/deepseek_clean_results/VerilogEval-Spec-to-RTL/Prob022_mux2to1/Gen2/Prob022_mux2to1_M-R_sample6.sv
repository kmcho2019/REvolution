module TopModule (
    input a,
    input b,
    input sel,
    output reg out
);
    always @(a or b or sel) begin
        if (sel) begin
            out = b;
        end else begin
            out = a;
        end
    end
endmodule