module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (~resetn) begin
        q <= 16'd0;
    end else begin
        for (int i = 0; i < 16; i++) begin
            if (i < 8 && byteena[0]) begin
                q[i] <= d[i];
            end else if (i >= 8 && byteena[1]) begin
                q[i] <= d[i];
            end
        end
    end
end

endmodule