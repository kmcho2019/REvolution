module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] register_array [0:7];

integer i;

always @(posedge clk) begin
    for (i = 0; i < 8; i = i + 1) begin
        register_array[i] <= d[i];
    end
end

always @(*) begin
    for (i = 0; i < 8; i = i + 1) begin
        q[i] = register_array[i];
    end
end

endmodule