module TopModule(
    input  [254:0] in,
    output [7:0] out
);

reg [8:0] count;

always @(in) begin
    count = 9'd0;
    for (int i = 0; i < 32; i++) begin
        if (i < 31) begin
            count = count + {{8{1'b0}}, in[8*i +: 8]};
        end else begin
            count = count + {{8{1'b0}}, in[8*i +: 7]};
        end
    end
end

assign out = count[7:0];

endmodule