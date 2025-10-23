module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

reg [15:0] data_to_write;
reg [15:0] mask;

always @(*) begin
    mask = 16'd0;
    data_to_write = q;
    
    if (byteena[0]) begin
        mask[7:0] = 8'd255; // Enable lower byte
        data_to_write[7:0] = d[7:0];
    end
    
    if (byteena[1]) begin
        mask[15:8] = 8'd255; // Enable upper byte
        data_to_write[15:8] = d[15:8];
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0;
    end else begin
        q <= (q & ~mask) | (data_to_write & mask);
    end
end

endmodule