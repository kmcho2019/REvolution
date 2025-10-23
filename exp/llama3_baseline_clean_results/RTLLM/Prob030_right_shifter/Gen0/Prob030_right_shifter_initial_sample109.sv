module right_shifter(
    input clk,
    input d,
    output [7:0] q
    );

reg [7:0] q;

initial
    q = 8'b0;

always @ (posedge clk) begin
    reg [7:0] temp_q;
    temp_q = q >> 1;
    temp_q[7] = d;
    q <= temp_q;
end

endmodule