module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output [15:0]  q
);

reg [7:0] q_upper;
reg [7:0] q_lower;

wire ce_upper = byteena[1];
wire ce_lower = byteena[0];

always @(posedge clk) begin
    if (!resetn) begin
        q_upper <= 8'b0;
        q_lower <= 8'b0;
    end else begin
        if (ce_upper)
            q_upper <= d[15:8];
        if (ce_lower)
            q_lower <= d[7:0];
    end
end

assign q = {q_upper, q_lower};

endmodule