module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
    end else if (count == 10'd999) begin
        count <= 10'd0;
    end else begin
        // x9 + x7 + x5 + x3 + x2 + x1 + x0
        count <= {count[8:0], (count[9] ^ count[6] ^ count[4] ^ count[2] ^ count[1] ^ count[0])};
    end
end

assign q = count;

endmodule