module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

integer i;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            if (i < 8) // lower byte
                q[i] <= byteena[0] ? d[i] : q[i];
            else // upper byte
                q[i] <= byteena[1] ? d[i] : q[i];
        end
    end
end

endmodule