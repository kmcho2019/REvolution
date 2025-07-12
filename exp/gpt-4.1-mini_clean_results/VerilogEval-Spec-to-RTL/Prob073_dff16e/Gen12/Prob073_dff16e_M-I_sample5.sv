module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

wire any_byte_enable = |byteena;

reg [15:0] next_q;

always @(*) begin
    // Default: retain current q
    next_q = q;

    if (!resetn) begin
        next_q = 16'b0;
    end else if (any_byte_enable) begin
        // For each byte, update only if enabled; else retain current byte
        next_q[7:0]  = byteena[0] ? d[7:0] : q[7:0];
        next_q[15:8] = byteena[1] ? d[15:8] : q[15:8];
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule