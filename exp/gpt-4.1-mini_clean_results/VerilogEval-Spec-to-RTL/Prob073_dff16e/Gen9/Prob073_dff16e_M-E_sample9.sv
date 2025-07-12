module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

integer i;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Update bits [7:0] only if byteena[0] is set
        for (i = 0; i < 8; i = i + 1) begin
            if (byteena[0])
                q[i] <= d[i];
            else
                q[i] <= q[i];
        end
        // Update bits [15:8] only if byteena[1] is set
        for (i = 8; i < 16; i = i + 1) begin
            if (byteena[1])
                q[i] <= d[i];
            else
                q[i] <= q[i];
        end
    end
end

endmodule