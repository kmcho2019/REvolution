module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    for (int i = 0; i < 16; i++) begin
        if (~resetn) begin
            q[i] <= 1'b0;
        end else if ((i < 8 && byteena[0]) || (i >= 8 && byteena[1])) begin
            q[i] <= d[i];
        end
    end
end

endmodule