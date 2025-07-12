module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output [15:0]  q
);

reg [7:0] q_upper;
reg [7:0] q_lower;

// Upper byte register with byteena[1]
always @(posedge clk) begin
    if (!resetn)
        q_upper <= 8'b0;
    else if (byteena[1])
        q_upper <= d[15:8];
    else
        q_upper <= q_upper;
end

// Lower byte register with byteena[0]
always @(posedge clk) begin
    if (!resetn)
        q_lower <= 8'b0;
    else if (byteena[0])
        q_lower <= d[7:0];
    else
        q_lower <= q_lower;
end

assign q = {q_upper, q_lower};

endmodule