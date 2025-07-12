module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [15:0] ena;

always @(*) begin
    ena = 16'd0;
    if (byteena[0]) begin
        ena[7:0] = 8'd255; // enable lower byte
    end
    if (byteena[1]) begin
        ena[15:8] = 8'd255; // enable upper byte
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        q <= 16'd0;
    end else begin
        for (int i = 0; i < 16; i++) begin
            if (ena[i]) begin
                q[i] <= d[i];
            end
        end
    end
end

endmodule