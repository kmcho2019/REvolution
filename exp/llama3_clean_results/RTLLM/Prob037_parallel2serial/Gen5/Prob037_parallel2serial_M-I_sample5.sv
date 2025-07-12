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
        data <= 4'b0;
        cnt <= 2'b0;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin
            data <= d;
            cnt <= 2'b00;
            valid <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            valid <= 1'b0;
        end
    end
end

assign valid_out = (cnt == 2'b00)? 1'b1 : 1'b0;

// Directly assign the MSB of data to dout and shift on subsequent cycles
always @(posedge clk) begin
    case(cnt)
        2'b00: dout <= data[3];
        2'b01: dout <= data[2];
        2'b10: dout <= data[1];
        2'b11: dout <= data[0];
    endcase
end

endmodule