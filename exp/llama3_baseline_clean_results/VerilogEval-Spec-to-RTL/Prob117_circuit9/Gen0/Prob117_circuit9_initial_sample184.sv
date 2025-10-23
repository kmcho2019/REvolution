module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] count = 3'b100; // initialize count to 4

always @(posedge clk) begin
    if (a == 1'b0) begin
        if (count == 3'b100) begin // if count is 4
            count <= 3'b000; // reset count to 0
        end else begin
            count <= count + 1'b1; // increment count
        end
    end else begin
        count <= 3'b100; // if a is 1, set count to 4
    end
end

assign q = count;

endmodule