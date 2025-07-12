module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] cnt;
reg [3:0] data_reg;
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 2'b00;
        data_reg <= 4'b0;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin // Last bit output, load new data
            data_reg <= d;
            cnt <= 2'b00;
            valid <= 1'b1;
        end else begin // Output next bit
            cnt <= cnt + 1'b1;
            valid <= 1'b0;
            data_reg <= {data_reg[2:0], 1'b0}; // Shift data
        end
    end
end

assign valid_out = valid;
assign dout = data_reg[3];

endmodule