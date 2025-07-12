// Combinational buffer implemented with always block
module TopModule (
    input wire in,
    output reg out
);
    always @(*) begin
        out = in;
    end
endmodule