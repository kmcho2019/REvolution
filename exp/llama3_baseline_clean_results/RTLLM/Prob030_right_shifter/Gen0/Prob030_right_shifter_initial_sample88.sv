module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

always @(posedge clk) begin
    reg [7:0] temp_q;
    temp_q = q >> 1;
    temp_q[7] = d;
    q <= temp_q;
end

initial begin
    q = 8'b0;
end

endmodule