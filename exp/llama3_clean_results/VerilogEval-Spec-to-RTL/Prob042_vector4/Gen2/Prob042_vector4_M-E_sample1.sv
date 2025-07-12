module TopModule(
    input [7:0] in,
    output reg [31:0] out
);

always @(*) begin
    if (in[7] == 1'b1) begin
        out = {24'd-1, in};
    end else begin
        out = {24'd0, in};
    end
end

endmodule