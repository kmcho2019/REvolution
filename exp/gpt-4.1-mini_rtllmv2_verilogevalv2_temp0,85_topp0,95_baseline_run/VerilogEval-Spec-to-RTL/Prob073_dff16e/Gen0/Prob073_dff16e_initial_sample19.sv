module TopModule (
    input        clk,
    input        resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Update upper byte if byteena[1] is set
        if (byteena[1])
            q[15:8] <= d[15:8];
        // Otherwise retain upper byte
        else
            q[15:8] <= q[15:8];

        // Update lower byte if byteena[0] is set
        if (byteena[0])
            q[7:0] <= d[7:0];
        // Otherwise retain lower byte
        else
            q[7:0] <= q[7:0];
    end
end

endmodule