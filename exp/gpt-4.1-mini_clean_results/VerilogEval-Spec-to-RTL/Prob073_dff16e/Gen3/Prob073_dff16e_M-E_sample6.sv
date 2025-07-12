module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

// Lower byte register (bits 7:0)
always @(posedge clk) begin
    if (!resetn)
        q[7:0] <= 8'b0;
    else if (byteena[0])
        q[7:0] <= d[7:0];
    // else retain previous value implicitly
end

// Upper byte register (bits 15:8)
always @(posedge clk) begin
    if (!resetn)
        q[15:8] <= 8'b0;
    else if (byteena[1])
        q[15:8] <= d[15:8];
    // else retain previous value implicitly
end

endmodule