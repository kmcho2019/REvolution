module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] counter;

// Sequential counter update
always @(posedge clk) begin
    if (a)
        counter <= 3'b100;  // hold at 4 when a=1
    else
        counter <= (counter == 3'b110) ? 3'b000 : counter + 1;
end

// Combinational output assignment
assign q = counter;

endmodule