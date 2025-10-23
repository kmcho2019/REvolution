module TopModule (
    input wire in,
    output reg out
);
    always @(in) begin
        out = in;
    end
endmodule