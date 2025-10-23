module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    wire [15:0] mask;
    assign mask = { {8{byteena[1]}}, {8{byteena[0]}} };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            q <= (q & ~mask) | (d & mask);
        end
    end

endmodule