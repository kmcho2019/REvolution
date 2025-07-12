module parallel2serial (
    input         clk,        // Clock signal
    input         rst_n,      // Reset signal (active low)
    input  [3:0]  d,          // 4-bit parallel data input
    output        valid_out,  // Valid signal indicating availability of serial output
    output        dout        // Serial output representing the converted data
);

reg [3:0] data;  // Data register
reg [1:0] cnt;  // Counter register
reg         valid;  // Valid signal

assign valid_out = valid;
assign dout = data[3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0000;
        cnt <= 2'b00;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin
            data <= d;
            cnt <= 2'b00;
            valid <= 1'b1;
        end else begin
            cnt <= cnt + 1;
            valid <= 1'b0;
            data <= {data[2:0], data[3]};
        end
    end
end

endmodule