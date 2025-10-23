module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001; // reset to 1 (binary: 0001)
    end else if (count == 4'b1010) begin // if count is 10 (binary: 1010)
        count <= 4'b0001; // wrap around to 1
    end else begin
        count <= count + 1'b1; // increment count
    end
end

assign q = count;

endmodule