module TopModule (
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg [99:0] temp_and;
reg [99:0] temp_or;
reg [99:0] temp_xor;

integer i;

always @(*) begin
    temp_and = in;
    temp_or = in;
    temp_xor = in;

    out_and = 1'b1;
    out_or = 1'b0;
    out_xor = 1'b0;

    for (i = 0; i < 100; i++) begin
        out_and = out_and & in[i];
        out_or = out_or | in[i];
        out_xor = out_xor ^ in[i];
    end
end

endmodule