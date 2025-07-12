module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] counter = 0;

always @(posedge clk) begin
    counter <= reset ? 0 : counter + 1;
end

assign q = counter;

endmodule