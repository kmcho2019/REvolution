module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] counter;

always @(posedge clk)
    if (reset) begin
        counter <= 4'd0;
    end else begin
        counter <= counter + 1'b1;
    end

assign q = counter;

endmodule