module TopModule(
    input  [255:0] in,
    output [7:0] out
);

reg [7:0] count;

always @(*) begin
    count = 8'b0;
    for (int i = 0; i < 256; i++) begin
        if (in[i]) begin
            count = count + 8'b1;
        end
    end
end

assign out = count;

endmodule