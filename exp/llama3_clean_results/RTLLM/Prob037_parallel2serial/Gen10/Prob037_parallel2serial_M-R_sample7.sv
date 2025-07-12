module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data;                   // Internal data register

// Counter logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
    end else if (cnt == 2'b11) begin
        cnt <= 2'b00;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Data register logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data <= 4'b0;
    end else if (cnt == 2'b11) begin
        data <= d;
    end else if (cnt != 2'b00) begin
        data <= {data[2:0], data[3]};
    end
end

// Output logic
assign valid_out = (cnt == 2'b00);
assign dout = data[3];

endmodule