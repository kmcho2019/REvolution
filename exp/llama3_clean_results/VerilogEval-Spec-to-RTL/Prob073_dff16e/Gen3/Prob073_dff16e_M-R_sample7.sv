module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [7:0] lower_byte;
reg [7:0] upper_byte;

assign q = {upper_byte, lower_byte};

always @(posedge clk) begin
    if (!resetn) begin
        lower_byte <= 8'd0;
        upper_byte <= 8'd0;
    end else begin
        if (byteena[0]) begin
            lower_byte <= d[7:0];
        end
        if (byteena[1]) begin
            upper_byte <= d[15:8];
        end
    end
end

endmodule