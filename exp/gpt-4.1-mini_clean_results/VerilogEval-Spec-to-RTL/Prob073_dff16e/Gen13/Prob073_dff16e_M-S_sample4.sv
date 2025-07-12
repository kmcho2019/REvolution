module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else begin
            q <= (q & ~{byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],
                        byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0]})
                 | (d & {byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],byteena[1],
                         byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0],byteena[0]});
        end
    end

endmodule