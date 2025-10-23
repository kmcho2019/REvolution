module TopModule(
    input  [254:0] in,  // 255-bit input
    output [7:0] out    // 8-bit output
);

reg [7:0] count;

always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 255; i++) begin
        if (in[i])
            count = count + 8'd1;
    end
end

assign out = count;

endmodule