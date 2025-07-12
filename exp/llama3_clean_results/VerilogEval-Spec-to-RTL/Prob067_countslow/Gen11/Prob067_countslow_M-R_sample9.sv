module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'd0;
    end else if (slowena) begin
        counter <= (counter == 4'd9) ? 4'd0 : counter + 4'd1;
    end
end

assign q = counter;

endmodule