module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    if (reset)
        counter <= 4'b0001;
    else if (counter == 4'b1010)
        counter <= 4'b0001;
    else
        counter <= counter + 1;
end

assign q = counter;

endmodule