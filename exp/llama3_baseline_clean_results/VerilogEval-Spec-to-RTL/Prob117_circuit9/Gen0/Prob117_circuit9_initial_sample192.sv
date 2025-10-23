module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (!a) begin
        counter <= counter + 1;
    end
end

assign q = counter;

endmodule