module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    reg [31:0] temp;

    always @(*) begin
        if (in[7] == 1'b0) begin
            temp = {24'd0, in};
        end else begin
            temp = {24'd0, in} | ({24{1'b1}} << 8);
        end
        out = temp;
    end

endmodule