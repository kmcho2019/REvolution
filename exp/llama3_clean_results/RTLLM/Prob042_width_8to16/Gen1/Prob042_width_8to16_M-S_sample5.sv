module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out_reg <= 0;
        data_lock <= 0;
    end else begin
        if (valid_in) begin
            if (data_lock == 0) begin
                data_lock <= data_in;
            end else begin
                data_out_reg <= {data_lock, data_in};
                data_lock <= 0;
            end
        end else begin
            data_out_reg <= 0;
        end
    end
end

assign valid_out = (data_out_reg != 0);
assign data_out = data_out_reg;

endmodule