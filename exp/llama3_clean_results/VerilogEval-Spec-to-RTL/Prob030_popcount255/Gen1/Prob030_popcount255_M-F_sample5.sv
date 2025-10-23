module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    reg [7:0] count;

    always @(*) begin
        count = 0;
        for (int i = 0; i < 255; i++) begin
            count = count + in[i];
        end
        out = count % 256; // ensure the count is within 8 bits
    end

endmodule