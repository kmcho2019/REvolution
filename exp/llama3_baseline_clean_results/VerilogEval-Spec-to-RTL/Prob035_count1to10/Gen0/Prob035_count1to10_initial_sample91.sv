module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 'b0001; // reset to 1
    end else if (count =='b1010) begin // count is        count <= 4'b0001; // wrap around to  end else begin
        count <= count + 1'b1; // increment count
    end
end

assign q = count;

endmodule