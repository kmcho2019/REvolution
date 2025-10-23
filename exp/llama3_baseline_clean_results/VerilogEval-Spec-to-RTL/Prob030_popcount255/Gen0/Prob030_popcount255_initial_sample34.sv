module TopModule(
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

always @(*) begin
    count = 8'b0;
    for (int i = 0; i < 32; i++) begin
        reg [7:0] chunk;
        if (i == 31) begin
            chunk = {8{in[7]}};
            for (int j = 0; j < 7; j++) begin
                chunk[j] = in[j];
            end
        end
        else begin
            chunk = in[(i*8)+:8];
        end
        for (int j = 0; j < 8; j++) begin
            if (chunk[j] == 1'b1) begin
                count = count + 1;
            end
        end
    end
    out = count;
end

endmodule