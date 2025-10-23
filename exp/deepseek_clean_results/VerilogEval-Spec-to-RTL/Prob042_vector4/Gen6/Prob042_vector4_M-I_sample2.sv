module TopModule (
    input [7:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out = in[7] ? {24'hFFFFFF, in} : {24'h000000, in};
    end
endmodule