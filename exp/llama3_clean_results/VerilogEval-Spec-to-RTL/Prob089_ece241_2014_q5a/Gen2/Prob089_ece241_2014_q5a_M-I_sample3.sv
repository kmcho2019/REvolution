module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [7:0] data;
reg [7:0] data_inv;
reg carry;
reg start;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        data <= 8'b0;
        data_inv <= 8'b0;
        carry <= 1'b0;
        start <= 1'b0;
    end else begin
        if (~start) begin
            start <= 1'b1;
            data[0] <= x;
        end else begin
            data <= {data[6:0], x};
            data_inv <= ~data;
            carry <= carry || data[7];
        end
    end
end

assign z = data_inv[0] ^ carry;

endmodule