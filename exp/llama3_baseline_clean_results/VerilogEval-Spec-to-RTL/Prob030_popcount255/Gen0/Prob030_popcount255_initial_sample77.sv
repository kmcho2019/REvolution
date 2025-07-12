module TopModule(
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

always @(in) begin
    reg [7:0] count_temp;
    count_temp = 8'd0;
    for (int i = 0; i < 255; i++) begin
        if (in[i]) count_temp = count_temp + 1;
    end
    count = count_temp;
end

assign out = count;

endmodule