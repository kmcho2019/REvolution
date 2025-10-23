module TopModule(
    input [2:0] in,
    output [1:0] out
);

    assign out[0] = in[0] ^ in[1] ^ in[2];
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    // Alternative implementation using arithmetic operations
    // assign out = {in[2], in[1]} + {in[0], 1'b0};

    // Direct population count implementation
    reg [1:0] count;
    always @(*) begin
        count = 2'b00;
        if (in[0]) count = count + 1;
        if (in[1]) count = count + 1;
        if (in[2]) count = count + 1;
        out = count;
    end

endmodule