module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    reg [99:0] temp_and;
    reg [99:0] temp_or;
    reg [99:0] temp_xor;

    always @(*) begin
        temp_and = {100{1'b1}};
        temp_or  = {100{1'b0}};
        temp_xor = {100{1'b0}};

        for (int i = 0; i < 100; i++) begin
            temp_and[i] = temp_and[i] & in[i];
            temp_or[i]  = temp_or[i]  | in[i];
            temp_xor[i] = temp_xor[i] ^ in[i];
        end

        out_and = &temp_and;
        out_or  = |temp_or;
        out_xor = ^temp_xor;
    end

endmodule