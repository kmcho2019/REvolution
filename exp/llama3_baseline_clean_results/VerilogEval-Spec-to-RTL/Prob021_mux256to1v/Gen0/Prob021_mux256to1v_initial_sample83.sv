module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    always @(*) begin
        out = in[({sel, 2'b00}) +: 4]; // Calculate the index and extract 4 bits
    end

endmodule