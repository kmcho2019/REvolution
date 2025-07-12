module TopModule(
    input  [254:0] in,  // 255-bit input vector
    output [7:0] out    // 8-bit output
);

reg [7:0] count;  // register to hold the count

always @(*) begin
    count = 8'd0;  // initialize count to 0
    for (int i = 0; i < 255; i++) begin
        if (in[i]) begin
            count = count + 1;
        end
    end
end

assign out = count;

endmodule