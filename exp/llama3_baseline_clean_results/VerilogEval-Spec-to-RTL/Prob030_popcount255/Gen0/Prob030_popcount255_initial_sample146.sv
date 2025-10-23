module TopModule(
    input  [255:0] in, 
    output [7:0] out
);

reg [7:0] count;

always @(in) begin
    count = 8'd0;
    for (int i = 0; i < 256; i++) begin
        count = count + {8'd0, in[i]};
    end
end

assign out = count;

endmodule