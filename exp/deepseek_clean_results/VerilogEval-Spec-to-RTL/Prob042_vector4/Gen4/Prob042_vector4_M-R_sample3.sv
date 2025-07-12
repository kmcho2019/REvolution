module TopModule (
    input [7:0] in,
    output reg [31:0] out
);
    always @(*) begin
        case (in[7])
            1'b0: out = {24'b0, in};
            1'b1: out = {24'b1, in};
        endcase
    end
endmodule