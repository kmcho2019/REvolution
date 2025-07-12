module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'd0;
    end else if (counter == 4'd9) begin
        counter <= 4'd0;
    end else begin
        counter <= counter + 4'd1;
    end
end

assign q = counter;

endmodule