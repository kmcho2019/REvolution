module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output reg out
);
    always @(*) begin
        if (sel)
            out = b;
        else
            out = a;
    end
endmodule