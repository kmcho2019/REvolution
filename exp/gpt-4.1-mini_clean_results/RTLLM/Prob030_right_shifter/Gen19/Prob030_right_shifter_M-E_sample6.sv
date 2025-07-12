module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    reg [7:0] temp;
    temp = q >> 1;
    temp[7] = d;
    q <= temp;
end

endmodule