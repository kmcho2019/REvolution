module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
    end else if (slowena) begin
        counter <= (counter == 9) ? 0 : counter + 1;
    end
end

assign q = counter;

endmodule