module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Create a tree-like structure of adders to count the number of '1's
reg [7:0] count;

always @(*) begin
    count = 8'b0;
    for (int i = 0; i < 255; i++) begin
        if (in[i]) begin
            count = count + 1'b1;
        end
    end
end

assign out = count;

endmodule