module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

reg [7:0] upper_q, lower_q;

always @(posedge clk) begin
    if (!resetn)
        upper_q <= 8'b0;
    else if (byteena[1])
        upper_q <= d[15:8];
end

always @(posedge clk) begin
    if (!resetn)
        lower_q <= 8'b0;
    else if (byteena[0])
        lower_q <= d[7:0];
end

always @(*) begin
    q = {upper_q, lower_q};
end

endmodule