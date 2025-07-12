module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001; // reset to 1
    end else if (count == 4'b1010) begin // count is 10, stay at 10
        count <= count;
    end else begin
        count <= count + 1; // increment count
    end
end

assign q = count;

endmodule