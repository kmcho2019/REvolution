module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

reg [7:0] upper_byte;
reg [7:0] lower_byte;

always @(posedge clk) begin
    if (!resetn)
        upper_byte <= 8'b0;
    else if (byteena[1])
        upper_byte <= d[15:8];
end

always @(posedge clk) begin
    if (!resetn)
        lower_byte <= 8'b0;
    else if (byteena[0])
        lower_byte <= d[7:0];
end

always @(*) begin
    q = {upper_byte, lower_byte};
end

endmodule