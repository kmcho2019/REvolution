module TopModule(
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Counting '1's in a 255-bit vector
always @(in) begin
    count = 8'd0;
    for (int i = 0; i < 255; i++) begin
        if (in[i]) begin
            count = count + 1;
        end
    end
end

assign out = count;

endmodule