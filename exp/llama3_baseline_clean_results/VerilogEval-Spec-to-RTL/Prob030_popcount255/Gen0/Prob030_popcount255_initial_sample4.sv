module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    reg [7:0] count;
    always @(*) begin
        count = 8'd0;
        for (int i = 0; i < 255; i++) begin
            count = count + in[i];
        end
        out = count;
    end

endmodule