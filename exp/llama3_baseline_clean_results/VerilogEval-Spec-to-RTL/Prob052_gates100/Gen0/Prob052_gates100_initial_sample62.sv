module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

reg [99:0] temp_and;
reg [99:0] temp_or;
reg temp_xor;

always @(in) begin
    temp_and = in[99];
    temp_or = 1'b0;
    temp_xor = in[99];

    for (int i = 98; i >= 0; i--) begin
        temp_and = temp_and & in[i];
        temp_or = temp_or | in[i];
        temp_xor = temp_xor ^ in[i];
    end

    out_and = temp_and;
    out_or = temp_or;
    out_xor = temp_xor;
end

endmodule