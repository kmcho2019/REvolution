module TopModule(
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] count;

initial begin
    count = 4'b0100;  // initialize count to 4
end

always @(posedge clk) begin
    if (~a) begin
        count = count + 1;
        if (count == 7) begin  // reset count to 0 when it reaches 7
            count = 0;
        end else if (count > 7) begin  // handle case when count is already greater than 7
            count = 1;
        end
    end
end

assign q = count;

endmodule