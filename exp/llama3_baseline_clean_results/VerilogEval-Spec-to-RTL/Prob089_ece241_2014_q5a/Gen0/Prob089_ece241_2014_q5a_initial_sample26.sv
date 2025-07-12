module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] acc; // accumulator to store the input bits
reg [31:0] complement; // register to store the 2's complement
reg [4:0] count; // counter to track the number of bits
reg is_complement; // flag to track whether we are generating the 2's complement

always @(posedge clk or posedge areset) begin
    if (areset) begin
        acc <= 32'd0;
        complement <= 32'd0;
        count <= 5'd0;
        is_complement <= 1'b0;
        z <= 1'b0;
    end else begin
        if (~is_complement) begin
            // accumulate the input bits
            acc <= {acc[30:0], x};
            count <= count + 5'd1;
            // check if we have received all the bits (i.e., count is 31)
            if (count == 5'd31) begin
                is_complement <= 1'b1;
            end
        end else begin
            // generate the 2's complement
            complement <= ~acc + 32'd1;
            // output the 2's complement bit by bit
            z <= complement[count - 5'd1];
            count <= count - 5'd1;
            // check if we have generated all the bits (i.e., count is 0)
            if (count == 5'd0) begin
                is_complement <= 1'b0;
            end
        end
    end
end

endmodule