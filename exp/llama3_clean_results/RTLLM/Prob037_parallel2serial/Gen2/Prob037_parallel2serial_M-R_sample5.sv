module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 2'b00;
    end else if (cnt == 2'b11) begin
        cnt <= 2'b00;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0;
    end else if (cnt == 2'b00) begin
        data <= d;
    end else begin
        data <= {data[2:0], data[3]}; // Shift data
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid <= 1'b0;
    end else if (cnt == 2'b11) begin
        valid <= 1'b1;
    end else begin
        valid <= 1'b0;
    end
end

assign valid_out = valid;
assign dout = data[3];

endmodule