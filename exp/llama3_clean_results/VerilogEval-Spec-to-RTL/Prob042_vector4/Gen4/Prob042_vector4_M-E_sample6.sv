module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    always @(*) begin
        if (in[7] == 1'b0) begin
            out = {24'b0, in};
        end else begin
            out = {24'b1, in};
        end
    end
endmodule