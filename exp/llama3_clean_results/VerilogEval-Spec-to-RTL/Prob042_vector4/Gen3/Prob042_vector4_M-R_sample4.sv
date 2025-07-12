module TopModule(
    input  [7:0] in,
    output [31:0] out
);

reg [31:0] temp_out;

always @(*) begin
    temp_out = { {24{in[7]}}, in };
    out = temp_out;
end

endmodule