module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input   [15:0] d,
    output  reg [15:0] q
);

wire [15:0] next_q;

// Compose next_q by selecting per byte whether to load new data or keep old data
assign next_q = { byteena[1] ? d[15:8] : q[15:8],
                  byteena[0] ? d[7:0]  : q[7:0] };

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else
        q <= next_q;
end

endmodule