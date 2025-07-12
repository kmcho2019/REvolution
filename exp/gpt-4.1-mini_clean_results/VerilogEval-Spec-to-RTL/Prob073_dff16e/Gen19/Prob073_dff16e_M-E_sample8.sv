module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

reg [7:0] q_lower;
reg [7:0] q_upper;

// Lower byte register
always @(posedge clk) begin
    if (!resetn)
        q_lower <= 8'b0;
    else if (byteena[0])
        q_lower <= d[7:0];
    else
        q_lower <= q_lower;
end

// Upper byte register
always @(posedge clk) begin
    if (!resetn)
        q_upper <= 8'b0;
    else if (byteena[1])
        q_upper <= d[15:8];
    else
        q_upper <= q_upper;
end

// Concatenate output
always @(*) begin
    q = {q_upper, q_lower};
end

endmodule