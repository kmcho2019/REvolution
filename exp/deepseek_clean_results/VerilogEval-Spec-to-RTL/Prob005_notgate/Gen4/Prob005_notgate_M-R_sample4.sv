module TopModule (
    input in,
    output reg out
);
    always @(in) begin
        out = ~in;
    end
endmodule