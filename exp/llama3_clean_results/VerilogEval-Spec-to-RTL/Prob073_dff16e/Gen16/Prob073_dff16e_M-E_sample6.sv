module WriteEnableGen(
    input [1:0] byteena,
    output reg [15:0] we
);

always @(*) begin
    we = 16'd0;
    if (byteena[1]) we[15:8] = 8'hFF;
    if (byteena[0]) we[7:0] = 8'hFF;
end

endmodule

module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [15:0] we;

WriteEnableGen we_gen(
    .byteena(byteena),
    .we(we)
);

always @(posedge clk) begin
    if (~resetn) q <= 16'd0;
    else begin
        for (int i = 0; i < 16; i++) begin
            if (we[i]) q[i] <= d[i];
        end
    end
end

endmodule