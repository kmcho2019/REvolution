module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter = 3'b100;

always @(posedge clk) begin
    if (a)
        counter <= counter;  // hold when a=1
    else
        counter <= (counter == 3'b110) ? 3'b000 : counter + 1;  // increment and wrap
end

assign q = counter;

endmodule