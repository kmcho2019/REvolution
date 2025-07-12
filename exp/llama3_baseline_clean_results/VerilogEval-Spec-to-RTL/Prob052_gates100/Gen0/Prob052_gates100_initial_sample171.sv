module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg [99:0] temp_in;
    reg temp_and;
    reg temp_or;
    reg temp_xor;

    always @(*) begin
        temp_and = 1;
        temp_or = 0;
        temp_xor = 0;
        for (int i = 0; i < 100; i++) begin
            temp_and = temp_and & in[i];
            temp_or = temp_or | in[i];
            temp_xor = temp_xor ^ in[i];
        end
        out_and = temp_and;
        out_or = temp_or;
        out_xor = temp_xor;
    end

endmodule