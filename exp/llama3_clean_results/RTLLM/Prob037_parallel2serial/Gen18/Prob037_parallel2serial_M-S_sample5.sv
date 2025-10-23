module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Data register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 4'd3) begin
        cnt <= 2'b00;
        data <= d;
    end else begin
        cnt <= cnt + 1;
    end
end

assign valid_out = (cnt != 4'd0);
assign dout = data[3];

always @ (posedge clk) begin
    if (cnt != 4'd3) begin
        data <= {data[2:0], data[3]};
    end
end

endmodule