module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1 synchronously
    end else begin
        count <= next_count;
    end
end

assign next_count = (reset) ? 4'd1 : 
                     (count == 4'd10) ? 4'd1 : 
                     (count < 4'd10) ? count + 1 : 
                     4'd0;

assign q = count;

endmodule