module TopModule(
    input  [255:0] in,
    output [7:0] out
);

// Count the number of '1's in the input vector
reg [7:0] count;

always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 256; i++) begin
        count = count + {{7{1'b0}}, in[i]};
    end
end

assign out = count;

endmodule