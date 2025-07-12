module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output reg out
);
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
        endcase
    end
endmodule