module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

wire en_upper = resetn & byteena[1];
wire en_lower = resetn & byteena[0];

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        if (en_upper)
            q[15:8] <= d[15:8];
        if (en_lower)
            q[7:0] <= d[7:0];
    end
end

endmodule