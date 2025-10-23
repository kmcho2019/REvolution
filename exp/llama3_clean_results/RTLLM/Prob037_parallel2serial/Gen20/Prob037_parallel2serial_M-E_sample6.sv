module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] shift_reg;
reg load_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        load_data <= 1'b0;
    end else if (load_data) begin
        shift_reg <= d;
        load_data <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], 1'b0};
    end
end

assign valid_out = (shift_reg != 4'b0) ? 1'b1 : 1'b0;
assign dout = shift_reg[3];

always @(posedge clk) begin
    if (shift_reg == 4'b1) begin
        load_data <= 1'b1;
    end
end

endmodule