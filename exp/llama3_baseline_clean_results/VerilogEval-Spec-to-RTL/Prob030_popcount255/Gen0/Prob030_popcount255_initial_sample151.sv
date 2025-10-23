module TopModule(
    input  [254:0] in,
    output [7:0]   out
);

reg [7:0] out_reg;

always @(*) begin
    out_reg = 8'd0;
    for (int i = 0; i < 32; i++) begin
        reg [2:0] count;
        count = 3'd0;
        for (int j = 0; j < 8; j++) begin
            count = count + in[i*8 + j];
        end
        out_reg = out_reg + {5'd0, count};
    end
    reg [2:0] count;
    count = 3'd0;
    for (int j = 0; j < 7; j++) begin
        count = count + in[32*8 + j];
    end
    out_reg = out_reg + {5'd0, count};
end

assign out = out_reg;

endmodule