module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    reg [7:0] count;

    always @(*) begin
        count = 8'd0;
        for (int i = 0; i < 255; i = i + 8) begin
            reg [7:0] block_count;
            block_count = 8'd0;
            for (int j = 0; j < 8; j++) begin
                if (in[i + j])
                    block_count = block_count + 1;
            end
            count = count + block_count;
        end
        out = count;
    end

endmodule